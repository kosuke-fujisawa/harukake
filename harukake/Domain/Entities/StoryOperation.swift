//
//  StoryOperation.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

/// LiteScript の実行命令を表現するドメインエンティティ
/// Clean Architecture の Domain 層に属し、外部フレームワークに依存しない
enum StoryOperation: Equatable {
    /// セリフ表示（話者名、本文）
    case say(speaker: String, text: String)
    /// 立ち絵表示（キャラクター名、位置、表情）
    case show(character: String, position: Position, expression: String)
    /// 立ち絵非表示（キャラクター名）
    case hide(character: String)
    /// 立ち絵移動（キャラクター名、新位置）
    case move(character: String, position: Position)
    /// 感情マーク表示（キャラクター名、マーク）
    case emote(character: String, mark: String)
    /// 背景切替（背景名）
    case bg(name: String)
    /// 待機（秒数）
    case wait(seconds: Double)
    /// 擬似選択肢（選択肢配列）
    case choice(items: [ChoiceItem])
    /// 終了
    case end
}

/// 立ち絵配置位置の値オブジェクト
enum Position: String, CaseIterable, Codable {
    case left = "L"
    case center = "C"
    case right = "R"
}

/// 選択肢項目の値オブジェクト
struct ChoiceItem: Equatable, Codable {
    let title: String
    let goto: String
}