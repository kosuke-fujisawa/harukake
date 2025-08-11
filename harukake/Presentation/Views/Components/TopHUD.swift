//
//  TopHUD.swift
//  harukake
//
//  このプロジェクトは CC BY-NC 4.0 ライセンスの下でライセンスされています。
//  プロジェクトルートのLICENSEファイルで完全なライセンス情報を参照してください。
//
//  非営利使用のみ。
//

import SwiftUI

/// ホーム画面上部のHUD（レベル表示と月次統計バー）
/// セーフエリア内で左上に配置される
struct TopHUD: View {
    @EnvironmentObject private var appState: AppStateObservable
    
    var body: some View {
        HStack(spacing: 12) {
            // レベルプレート
            HStack(spacing: 6) {
                Text("Lv")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(appState.currentLevel)")
                    .font(.headline)
                    .monospacedDigit()
            }
            .padding(.horizontal, 10)
            .frame(height: 36)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            
            // 3本バー（月次統計）
            MonthlyTripleBars()
                .frame(height: 36)
            
            Spacer()
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .padding(.top, 16)
    }
}

#Preview {
    TopHUD()
        .environmentObject({
            let appState = AppStateObservable()
            return appState
        }())
        .background(Color.gray.opacity(0.2))
}
