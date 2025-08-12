//
//  SettingsView.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

struct SettingsView: View {
    @State private var nickname = "田中"

    var body: some View {
        NavigationStack {
            Form {
                Section("プロフィール") {
                    HStack {
                        Text("ニックネーム")
                        TextField("ニックネーム", text: $nickname)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section("データ") {
                    Button("バックアップ") {
                        exportData()
                    }

                    Button("復元") {
                        importData()
                    }
                }

                Section("その他") {
                    NavigationLink("クレジット") {
                        CreditView()
                    }

                    HStack {
                        Text("アプリ情報")
                        Spacer()
                        Text("v1.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("設定")
            .onAppear {
                DebugLogger.logUIAction("SettingsView appeared")
            }
        }
    }

    private func exportData() {
        DebugLogger.logDataAction("Starting data backup")
        // 実際のエクスポート処理はここに実装
        DebugLogger.logDataAction("Data backup completed successfully")
    }

    private func importData() {
        DebugLogger.logDataAction("Starting data restore")
        // 実際のインポート処理はここに実装
        DebugLogger.logDataAction("Data restore completed successfully")
    }
}

struct CreditView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("遥かなる家計管理の道のり")
                .font(.title2)
                .fontWeight(.bold)

            Text("v1.0")
                .font(.caption)
                .foregroundStyle(.secondary)

            VStack(spacing: 10) {
                Text("支援")
                    .font(.headline)

                Button("支援サイト（ダミー）") {
                    print("支援サイトを開く")
                }
                .buttonStyle(.bordered)

                Button("問い合わせ（ダミー）") {
                    print("問い合わせフォームを開く")
                }
                .buttonStyle(.bordered)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("クレジット")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
}
