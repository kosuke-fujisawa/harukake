//
//  CGBackgroundController.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

/// CG背景の切り替えと管理を担当するコントローラー
/// 章進行・時間帯・キャラに応じて背景CGを切り替える
@MainActor
final class CGBackgroundController: ObservableObject {
    @Published var currentImageName: String = "cg_home_default"
    
    // MARK: - 設定関連
    @AppStorage("backgroundCGAnimationEnabled") private var animationEnabled = true
    @AppStorage("backgroundCGAutoSwitch") private var autoSwitchEnabled = true
    
    // MARK: - 背景切り替えメソッド
    /// 指定した背景CGに切り替える
    /// - Parameter name: Asset Catalogの画像名
    func set(image name: String) {
        guard name != currentImageName else { return }
        
        if animationEnabled {
            withAnimation(.easeInOut(duration: 0.25)) {
                self.currentImageName = name
            }
        } else {
            self.currentImageName = name
        }
    }
    
    // MARK: - プリロード処理
    /// アプリ起動時の先読み処理
    /// 将来的にリモート画像や大容量アセットのキャッシュに使用
    func preload() async {
        // 現状はAsset Catalogが自動解決するため特別な処理は不要
        // 将来のURL/Live2D対応時はここでキャッシュロジックを実装
    }
    
    // MARK: - 自動切り替え機能
    /// 時間帯に応じた自動切り替え
    func updateForTimeOfDay() {
        guard autoSwitchEnabled else { return }
        
        let hour = Calendar.current.component(.hour, from: Date())
        let newImageName: String
        
        switch hour {
        case 6..<18:
            newImageName = "cg_home_day"
        case 18..<22:
            newImageName = "cg_home_evening"
        default:
            newImageName = "cg_home_night"
        }
        
        // 画像が存在しない場合はデフォルトにフォールバック
        set(image: imageExists(newImageName) ? newImageName : "cg_home_default")
    }
    
    /// 章進行に応じた背景切り替え
    /// - Parameter chapter: 章番号
    func updateForChapter(_ chapter: Int) {
        guard autoSwitchEnabled else { return }
        
        let chapterImageName = "cg_home_chapter\(chapter)"
        set(image: imageExists(chapterImageName) ? chapterImageName : "cg_home_default")
    }
    
    // MARK: - ユーティリティ
    /// 指定した画像がAsset Catalogに存在するかチェック
    private func imageExists(_ name: String) -> Bool {
        return UIImage(named: name) != nil
    }
    
    // MARK: - メモリ管理
    /// メモリ警告時の処理
    func handleMemoryWarning() {
        // 必要に応じてキャッシュをクリア
        // 現状はAsset Catalogが自動管理するため特別な処理は不要
    }
}
