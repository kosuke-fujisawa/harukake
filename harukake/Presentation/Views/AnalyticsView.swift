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
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("2025年1月")
                    .font(.title2)
                    .padding()

                VStack(alignment: .leading, spacing: 10) {
                    Text("カテゴリ別合計")
                        .font(.headline)

                    CategorySummaryRow(category: "食費", amount: 25000, color: .blue)
                    CategorySummaryRow(category: "家賃", amount: 80000, color: .orange)
                    CategorySummaryRow(category: "光熱", amount: 6000, color: .green)
                    CategorySummaryRow(category: "通信", amount: 4000, color: .purple)
                }
                .padding()

                VStack(alignment: .leading, spacing: 10) {
                    Text("前月比")
                        .font(.headline)

                    HStack {
                        Text("食費: +\(CurrencyFormatter.formatWithSeparator(2000))")
                        Spacer()
                        Text("📈")
                    }
                    Text("「今月は外食多め？」")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()

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
}
