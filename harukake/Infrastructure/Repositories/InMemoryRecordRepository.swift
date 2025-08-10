//
//  InMemoryRecordRepository.swift
//  harukake
//
//  Infrastructure層 - Repository実装
//  メモリ内での記録データ永続化を実装
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

/// インメモリでの記録データリポジトリ実装
class InMemoryRecordRepository: RecordRepositoryProtocol {
    private var records: [RecordItem] = []

    func getAllRecords() -> [RecordItem] {
        return records
    }

    func addRecord(_ record: RecordItem) {
        records.append(record)
        DebugLogger.logDataAction("Record saved - Category: \(record.category.displayName), Amount: ¥\(record.amount)")
    }

    func getRecordsForMonth(_ month: Date) -> [RecordItem] {
        let calendar = Calendar.current
        return records.filter { record in
            calendar.isDate(record.date, equalTo: month, toGranularity: .month)
        }
    }
}
