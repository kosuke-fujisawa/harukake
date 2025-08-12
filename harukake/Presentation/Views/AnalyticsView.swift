//
//  AnalyticsView.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject var appState: AppStateObservable
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("現在の分析")
                    .font(.title2)
                    .padding()

                if appState.records.isEmpty {
                    VStack {
                        Text("まだ記録がありません")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text("記録を追加すると分析が表示されます")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("カテゴリ別合計")
                            .font(.headline)

                        let categoryTotals = appState.calculateCategoryTotals(for: Date())
                        
                        ForEach(
                            Array(categoryTotals.keys).sorted(by: { $0.displayName < $1.displayName }),
                            id: \.self
                        ) { category in
                            if let amount = categoryTotals[category], amount > 0 {
                                CategorySummaryRow(
                                    category: category.displayName,
                                    amount: amount,
                                    color: CategoryColorPalette.color(for: category)
                                )
                            }
                        }
                    }
                    .padding()

                    VStack(alignment: .leading, spacing: 10) {
                        Text("月合計")
                            .font(.headline)
                        
                        let monthlyTotal = appState.calculateMonthlyTotal(for: Date())
                        HStack {
                            Text("合計支出: \(CurrencyFormatter.formatJPY(monthlyTotal))")
                            Spacer()
                        }
                        Text("「記録数: \(appState.records.count) 件」")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }

                Spacer()
            }
            .navigationTitle("分析")
            .onAppear {
                DebugLogger.logUIAction("AnalyticsView appeared")
            }
        }
    }
}

struct CategorySummaryRow: View {
    let category: String
    let amount: Int
    let color: Color

    var body: some View {
        HStack {
            Rectangle()
                .fill(color)
                .frame(width: 4, height: 20)
            Text(category)
            Spacer()
            Text(CurrencyFormatter.formatJPY(amount))
                .fontWeight(.medium)
        }
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(AppStateObservable.mock())
}
