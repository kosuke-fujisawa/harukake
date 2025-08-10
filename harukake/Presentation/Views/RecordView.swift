//
//  RecordView.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

struct RecordView: View {
    @StateObject private var appState = AppStateObservable()
    @State private var selectedDate = Date()
    @State private var selectedCategory = Category.shokuhi
    @State private var amount = ""
    @State private var memo = ""
    @State private var showingComment = false
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section("記録情報") {
                    DatePicker("日付", selection: $selectedDate, displayedComponents: .date)

                    Picker("カテゴリ", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.displayName).tag(category)
                        }
                    }

                    HStack {
                        Text("金額")
                        TextField("0", text: $amount)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("円")
                    }

                    TextField("メモ（任意）", text: $memo)
                }

                Section {
                    Button("保存") {
                        saveRecord()
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(amount.isEmpty)
                }

                if !appState.records.isEmpty {
                    Section("最近の記録") {
                        ForEach(appState.records.suffix(3).reversed(), id: \.id) { record in
                            HStack {
                                Text(record.category.displayName)
                                Spacer()
                                Text("¥\(record.amount)")
                            }
                        }
                    }
                }
            }
            .navigationTitle("記録")
            .onAppear {
                DebugLogger.logUIAction("RecordView appeared")
            }
            .sheet(isPresented: $showingComment) {
                CommentView(comment: appState.currentComment) {
                    DebugLogger.logUIAction("Closing CommentSheet")
                    appState.clearComment()
                    showingComment = false
                }
            }
            .alert("入力エラー", isPresented: $showingErrorAlert) {
                Button("修正する") {
                    // フォーカスを金額フィールドに戻す（代替案提示）
                }
                Button("キャンセル") {
                    clearForm()
                }
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func saveRecord() {
        guard let amountValue = Int(amount) else {
            showError("金額には数値を入力してください。\n例：1000、500")
            return
        }

        guard amountValue > 0 else {
            showError("金額は1円以上で入力してください。\n入力値: \(amountValue)円")
            return
        }

        appState.addRecord(
            date: selectedDate,
            category: selectedCategory,
            amount: amountValue,
            memo: memo
        )

        clearForm()

        DebugLogger.logUIAction("Opening CommentSheet")
        showingComment = true
    }

    /// エラーメッセージを表示（代替案提示付き）
    private func showError(_ message: String) {
        errorMessage = message
        showingErrorAlert = true
        DebugLogger.logError("Validation error: \(message)")
    }

    /// フォーム入力値をクリア
    private func clearForm() {
        amount = ""
        memo = ""
    }
}

struct CommentView: View {
    let comment: Comment?
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("💬 キャラクターコメント")
                .font(.headline)

            if let comment = comment {
                VStack(spacing: 10) {
                    Text(comment.character.displayName)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("\"\(comment.message)\"")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(10)
                }
            }

            Button("閉じる") {
                onClose()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    RecordView()
}
