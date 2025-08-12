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
        // TODO: AnalyticsQueryService実装時に復活させる
        // 一時的にプレースホルダー表示
        HStack {
            Text("月次グラフ（準備中）")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text("記録数: \(appState.records.count)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(height: height)
        .padding(.horizontal, 16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .contentShape(Rectangle())
        .onTapGesture {
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
