//
//  MonthlyBarSparkline.swift
//  harukake
//
//  このプロジェクトは CC BY-NC 4.0 ライセンスの下でライセンスされています。
//  プロジェクトルートのLICENSEファイルで完全なライセンス情報を参照してください。
//
//  非営利使用のみ。
//

import SwiftUI

/// ホーム画面上部に表示する今月の収支ミニ棒グラフ
/// 日別収支を視覚的に表示し、タップで詳細分析へ遷移
struct MonthlyBarSparkline: View {
    @EnvironmentObject private var appState: AppStateObservable
    let height: CGFloat
    
    var body: some View {
        let data = appState.currentMonthDailyNet
        let maxAbsValue = max(1, data.compactMap { abs($0) }.max() ?? 1)
        
        HStack(spacing: 2) {
            // 日別棒グラフ
            ForEach(Array(data.enumerated()), id: \.offset) { _, value in
                VStack(spacing: 0) {
                    // 上向き（収入・黒字部分）
                    Rectangle()
                        .fill(Color.primary.opacity(0.85))
                        .frame(height: value > 0 ? CGFloat(value / maxAbsValue) * (height * 0.4) : 0)
                    
                    // 中央基準線
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 1)
                    
                    // 下向き（支出・赤字部分）
                    Rectangle()
                        .fill(Color.red.opacity(0.85))
                        .frame(height: value < 0 ? CGFloat(-value / maxAbsValue) * (height * 0.4) : 0)
                }
                .frame(width: max(1, barWidth(for: data.count)))
            }
            
            Spacer(minLength: 8)
            
            // 右端サマリーテキスト
            VStack(alignment: .trailing, spacing: 2) {
                Text(appState.monthSummaryText)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }
        }
        .frame(height: height)
        .padding(.horizontal, 16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .contentShape(Rectangle())
        .onTapGesture {
            // 詳細分析画面への遷移（今回はプレースホルダー）
            DebugLogger.logUIAction("MonthlyBarSparkline tapped - navigating to monthly analytics")
        }
    }
    
    /// 棒グラフの幅を計算
    private func barWidth(for dayCount: Int) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let availableWidth = screenWidth - 64 - 120 // パディング + サマリー領域
        return availableWidth / CGFloat(max(28, dayCount))
    }
}

#Preview {
    VStack(spacing: 20) {
        MonthlyBarSparkline(height: 60)
            .environmentObject({
                let appState = AppStateObservable()
                return appState
            }())
        
        MonthlyBarSparkline(height: 68)
            .environmentObject({
                let appState = AppStateObservable()
                return appState
            }())
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
