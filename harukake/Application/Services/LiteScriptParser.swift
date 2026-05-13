//
//  LiteScriptParser.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

/// LiteScript構文をパースしてStoryOperationに変換するアプリケーションサービス
/// Clean Architecture の Application 層に属する
class LiteScriptParser {
    
    /// 名前→内部IDのマッピング
    private let characterIdMap: [String: String] = [
        "ひかり": "hikari",
        "れいな": "reina",
        "まゆ": "mayu",
        "誠": "makoto",
        "大地": "daichi",
        "自分": "self"
    ]
    
    /// パース結果
    struct ParseResult {
        let operations: [StoryOperation]
        let labels: [String: Int] // ラベル名 -> 命令インデックス
    }
    
    /// LiteScriptテキストをパースする
    func parse(_ script: String) -> ParseResult {
        let lines = script.components(separatedBy: .newlines)
        var operations: [StoryOperation] = []
        var labels: [String: Int] = [:]
        var i = 0
        
        while i < lines.count {
            let line = lines[i].trimmingCharacters(in: .whitespaces)
            
            // 空行・コメント行をスキップ
            if line.isEmpty || line.hasPrefix("#") {
                i += 1
                continue
            }
            
            // ラベル行の処理
            if line.hasPrefix("::") {
                let labelName = String(line.dropFirst(2))
                labels[labelName] = operations.count
                i += 1
                continue
            }
            
            // 擬似選択肢ブロックの処理
            if line.hasPrefix("?") {
                let (choiceOperation, nextIndex) = parseChoiceBlock(lines, startIndex: i)
                if let operation = choiceOperation {
                    operations.append(operation)
                }
                i = nextIndex
                continue
            }
            
            // コマンド行の処理
            if line.hasPrefix("[") && line.hasSuffix("]") {
                if let operation = parseCommand(line) {
                    operations.append(operation)
                } else {
                    print("Script error L\(i+1): Unknown command '\(line)'")
                }
                i += 1
                continue
            }
            
            // セリフ行の処理
            if let operation = parseSay(line) {
                operations.append(operation)
            } else {
                print("Script error L\(i+1): Invalid dialogue format '\(line)'")
            }
            
            i += 1
        }
        
        return ParseResult(operations: operations, labels: labels)
    }
    
    /// コマンド行をパースする
    private func parseCommand(_ line: String) -> StoryOperation? {
        let content = String(line.dropFirst().dropLast()) // [ ] を除去
        let parts = content.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        
        guard !parts.isEmpty else { return nil }
        
        let command = parts[0].uppercased()
        
        switch command {
        case "BG":
            guard parts.count >= 2 else { return nil }
            return .bg(name: parts[1])
            
        case "SHOW":
            guard parts.count >= 4,
                  let position = Position(rawValue: parts[2]) else { return nil }
            return .show(character: parts[1], position: position, expression: parts[3])
            
        case "HIDE":
            guard parts.count >= 2 else { return nil }
            return .hide(character: parts[1])
            
        case "MOVE":
            guard parts.count >= 3,
                  let position = Position(rawValue: parts[2]) else { return nil }
            return .move(character: parts[1], position: position)
            
        case "EMOTE":
            guard parts.count >= 3 else { return nil }
            return .emote(character: parts[1], mark: parts[2])
            
        case "WAIT":
            guard parts.count >= 2,
                  let seconds = Double(parts[1]) else { return nil }
            return .wait(seconds: seconds)
            
        case "END":
            return .end
            
        default:
            return nil
        }
    }
    
    /// セリフ行をパースする
    private func parseSay(_ line: String) -> StoryOperation? {
        guard let colonIndex = line.firstIndex(of: ":") else { return nil }
        
        let speaker = String(line[..<colonIndex]).trimmingCharacters(in: .whitespaces)
        let text = String(line[line.index(after: colonIndex)...]).trimmingCharacters(in: .whitespaces)
        
        guard !speaker.isEmpty, !text.isEmpty else { return nil }
        
        return .say(speaker: speaker, text: text)
    }
    
    /// 擬似選択肢ブロックをパースする
    private func parseChoiceBlock(_ lines: [String], startIndex: Int) -> (StoryOperation?, Int) {
        var choiceItems: [ChoiceItem] = []
        var i = startIndex + 1 // "?" 行の次から開始
        
        while i < lines.count {
            let line = lines[i].trimmingCharacters(in: .whitespaces)
            
            // 選択肢行でない場合はブロック終了
            if !line.hasPrefix("-") {
                break
            }
            
            // "- 選択肢テキスト -> ラベル" をパース
            let content = String(line.dropFirst()).trimmingCharacters(in: .whitespaces)
            let arrowParts = content.components(separatedBy: " -> ")
            
            if arrowParts.count == 2 {
                let title = arrowParts[0].trimmingCharacters(in: .whitespaces)
                let goto = arrowParts[1].trimmingCharacters(in: .whitespaces)
                choiceItems.append(ChoiceItem(title: title, goto: goto))
            } else {
                print("Script error L\(i+1): Invalid choice format '\(line)'")
            }
            
            i += 1
        }
        
        // 最大2択まで
        if choiceItems.count > 2 {
            print("Script warning: Choice limited to 2 options, truncating")
            choiceItems = Array(choiceItems.prefix(2))
        }
        
        let operation = choiceItems.isEmpty ? nil : StoryOperation.choice(items: choiceItems)
        return (operation, i)
    }
}