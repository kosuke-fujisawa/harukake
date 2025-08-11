//
//  TopStatusBar.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

/// ホーム画面上部のステータス表示バー
/// レベル、今月支出、貯金額、入力回数、ジュエルを表示
struct TopStatusBar: View {
    // TODO: 実際のデータ連携は後で実装
    @State private var level: Int = 1
    @State private var monthlySpending: Int = 0
    @State private var savings: Int = 0
    @State private var recordCount: Int = 0
    @State private var jewels: Int = 0
    
    var body: some View {
        HStack(spacing: 24) {
            StatItem(value: "\(level)", label: "Lv")
            StatItem(value: formatCurrency(monthlySpending), label: "支出")
            StatItem(value: formatCurrency(savings), label: "貯蓄")
            StatItem(value: "\(recordCount)", label: "入力日数")
            StatItem(value: "\(jewels)", label: "💎")
        }
        .padding(.horizontal, 16)
        .frame(height: 64)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private func formatCurrency(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "¥0"
    }
}

/// ステータスアイテムの個別コンポーネント
struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.8))
                .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
        }
        .frame(minWidth: 72, alignment: .center)
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        TopStatusBar()
            .padding()
    }
}
