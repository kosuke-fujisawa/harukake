//
//  RecordRepositoryProtocol.swift
//  harukake
//
//  Domain層 - Repository抽象化
//  記録データの永続化を抽象化するプロトコル
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

/// 記録データのリポジトリプロトコル（Domain層では抽象化のみ）
protocol RecordRepositoryProtocol {
    func getAllRecords() -> [RecordItem]
    func addRecord(_ record: RecordItem)
    func getRecordsForMonth(_ month: Date) -> [RecordItem]
}
