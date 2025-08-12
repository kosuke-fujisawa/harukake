//
//  MonthlyTripleBars.swift
//  harukake
//
//  このプロジェクトは CC BY-NC 4.0 ライセンスの下でライセンスされています。
//  プロジェクトルートのLICENSEファイルで完全なライセンス情報を参照してください。
//
//  非営利使用のみ。
//

import SwiftUI

/// 今月の収入・支出・収支を3本のバーで表示するコンポーネント
/// タップで月間分析画面へ遷移
struct MonthlyTripleBars: View {
    @EnvironmentObject private var appState: AppStateObservable
    @State private var showingAnalytics = false
    
    var body: some View {
        // TODO: AnalyticsQueryService実装時に復活させる
        let income = 0.0 // プレースホルダー
        let expense = Double(appState.records.reduce(0) { $0 + $1.amount })
        let balance = income - expense
        
        let maxValue = max(abs(income), abs(expense), abs(balance), 10000) // 最小10000で確実に表示
        
        HStack(spacing: 12) {
            // 収入バー
            BarColumn(
                value: income,
                maxValue: maxValue,
                color: .gray,
                label: "収入"
            )
            
            // 支出バー
            BarColumn(
                value: expense,
                maxValue: maxValue,
                color: .red,
                label: "支出"
            )
            
            // 収支バー
            BarColumn(
                value: balance,
                maxValue: maxValue,
                color: balance >= 0 ? Color.accentColor : .orange,
                label: "収支"
            )
        }
        .frame(height: 36)
        .padding(.horizontal, 10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.primary.opacity(0.2), lineWidth: 0.5)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            DebugLogger.logUIAction("MonthlyTripleBars tapped - navigating to analytics")
            showingAnalytics = true
        }
        .sheet(isPresented: $showingAnalytics) {
            AnalyticsView()
        }
    }
}

/// 3本バーの個別コンポーネント
private struct BarColumn: View {
    let value: Double
    let maxValue: Double
    let color: Color
    let label: String
    
    var body: some View {
        VStack(spacing: 2) {
            // バー表示領域
            VStack(spacing: 0) {
                Spacer()
                Rectangle()
                    .fill(color.opacity(0.85))
                    .frame(height: max(4, CGFloat(abs(value) / maxValue) * 16) + 2)
            }
            .frame(height: 20)
            
            // ラベル
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack(spacing: 20) {
        MonthlyTripleBars()
            .environmentObject({
                let appState = AppStateObservable()
                return appState
            }())
        
        HStack(spacing: 12) {
            Text("Lv 5")
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            
            MonthlyTripleBars()
                .environmentObject({
                    let appState = AppStateObservable()
                    return appState
                }())
        }
        .padding()
    }
    .background(Color.gray.opacity(0.1))
}
