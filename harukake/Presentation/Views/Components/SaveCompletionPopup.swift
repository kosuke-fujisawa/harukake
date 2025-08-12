//
//  SaveCompletionPopup.swift
//  harukake
//
//  Presentation層 - Component
//  保存完了ポップアップ（マネーフォワード風）
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

/// 保存完了ポップアップ（マネーフォワード風デザイン）
struct SaveCompletionPopup: View {
    let record: RecordItem
    let miniReaction: MiniReaction
    let onComplete: () -> Void
    let onEdit: () -> Void
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // ヘッダー部分
            VStack(spacing: 8) {
                Text("支出を保存しました")
                    .font(.headline)
                    .fontWeight(.bold)
                
                // 記録情報表示
                recordInfoView
            }
            
            // SDキャラ＋吹き出しリアクション領域
            ReactionPaneView(reaction: miniReaction)
            
            // アクションボタン群
            HStack(spacing: 12) {
                Button("完了") {
                    onComplete()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                
                Button("修正") {
                    onEdit()
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
                
                Button("続けて入力") {
                    onContinue()
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    /// 記録情報表示部分
    private var recordInfoView: some View {
        HStack {
            Text(formatDate(record.date))
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(record.category.displayName)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(4)
            
            Text(CurrencyFormatter.formatJPY(record.amount))
                .font(.caption)
                .fontWeight(.semibold)
            
            Text("現金") // TODO: 実際の支払い元を実装時に置き換え
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    /// 日付フォーマッター（再利用のためstatic）
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale.current
        return formatter
    }()
    
    /// 日付フォーマット
    private func formatDate(_ date: Date) -> String {
        return Self.dateFormatter.string(from: date)
    }
}

#Preview {
    SaveCompletionPopup(
        record: RecordItem(
            date: Date(),
            category: .shokuhi,
            amount: 1200,
            memo: "昼食"
        ),
        miniReaction: MiniReaction(characterID: .hikari, text: "節約上手だね！"),
        onComplete: {},
        onEdit: {},
        onContinue: {}
    )
    .padding()
}
