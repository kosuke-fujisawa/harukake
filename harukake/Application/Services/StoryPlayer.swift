//
//  StoryPlayer.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation
import Combine

/// ストーリー再生設定
struct StorySettings {
    /// 擬似選択時に「自分: ...」を1行挟むかどうか
    var showSelfUtterance = true
}

/// LiteScriptの再生制御を行うアプリケーションサービス
/// Clean Architecture の Application 層に属する
class StoryPlayer: ObservableObject {
    
    // MARK: - Published Properties (Infrastructure層でObservableObject化)
    
    /// 現在表示中のセリフ（話者名、本文）
    @Published var currentLine: (speaker: String, text: String)?
    /// 選択肢待ち状態の選択肢一覧
    @Published var pendingChoice: [ChoiceItem]?
    /// 現在の舞台状況
    @Published var stage = StoryStage()
    /// プレイヤー設定
    @Published var settings = StorySettings()
    
    // MARK: - Private Properties
    
    private var operations: [StoryOperation] = []
    private var labels: [String: Int] = [:]
    private var programCounter = 0
    private var waitTimer: Timer?
    
    // MARK: - Public Methods
    
    /// スクリプトをロードして再生開始
    func loadScript(_ script: String) {
        let parser = LiteScriptParser()
        let result = parser.parse(script)
        
        operations = result.operations
        labels = result.labels
        programCounter = 0
        
        // 初期状態をクリア
        currentLine = nil
        pendingChoice = nil
        stage = StoryStage()
        
        // 再生開始
        step()
    }
    
    /// 次の命令を実行（タップ時やWAIT完了時に呼び出し）
    func step() {
        // 選択肢待ち中は無効
        if pendingChoice != nil {
            return
        }
        
        // 現在のセリフをクリア
        currentLine = nil
        
        executeNext()
    }
    
    /// 選択肢を選択
    func choose(_ index: Int) {
        guard let choices = pendingChoice,
              index >= 0 && index < choices.count else {
            return
        }
        
        let selectedChoice = choices[index]
        pendingChoice = nil
        
        // 自己発話を表示するかどうか
        if settings.showSelfUtterance {
            currentLine = ("自分", selectedChoice.title)
            // 次のステップでラベルジャンプを実行するため、クロージャでラップ
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.jumpToLabel(selectedChoice.goto)
            }
        } else {
            // 即座にラベルジャンプ
            jumpToLabel(selectedChoice.goto)
        }
    }
    
    // MARK: - Private Methods
    
    /// 次の命令を実行
    private func executeNext() {
        // タイマーをクリア
        waitTimer?.invalidate()
        waitTimer = nil
        
        // プログラム終了チェック
        guard programCounter < operations.count else {
            print("Story completed")
            return
        }
        
        let operation = operations[programCounter]
        programCounter += 1
        
        switch operation {
        case .say(let speaker, let text):
            currentLine = (speaker, text)
            // セリフはタップ待ちで停止
            
        case .show(let character, let position, let expression):
            stage.showCharacter(character, at: position, expression: expression)
            executeNext() // 即座に次へ
            
        case .hide(let character):
            stage.hideCharacter(character)
            executeNext() // 即座に次へ
            
        case .move(let character, let position):
            stage.moveCharacter(character, to: position)
            executeNext() // 即座に次へ
            
        case .emote(let character, let mark):
            stage.showEmote(for: character, mark: mark)
            executeNext() // 即座に次へ
            
        case .bg(let name):
            stage.changeBackground(name)
            executeNext() // 即座に次へ
            
        case .wait(let seconds):
            // 指定秒数後に自動で次へ
            waitTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { [weak self] _ in
                self?.step()
            }
            
        case .choice(let items):
            pendingChoice = items
            // 選択待ちで停止
            
        case .end:
            print("Story ended")
            // 終了
        }
    }
    
    /// 指定ラベルにジャンプ
    private func jumpToLabel(_ labelName: String) {
        if let labelIndex = labels[labelName] {
            programCounter = labelIndex
            executeNext()
        } else {
            print("Script error: Label '\(labelName)' not found")
            // エラー時はストーリー終了
        }
    }
}