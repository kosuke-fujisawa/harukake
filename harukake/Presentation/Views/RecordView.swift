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
    @EnvironmentObject var appState: AppStateObservable
    @State private var selectedDate = Date()
    @State private var selectedCategory = Category.shokuhi
    @State private var amount = ""
    @State private var memo = ""
    @State private var lastSavedRecord: RecordItem?
    @State private var currentComment: Comment?
    @State private var currentMiniReaction: MiniReaction?
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    @FocusState private var isAmountFieldFocused: Bool

    var body: some View {
        NavigationStack {
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
                            .focused($isAmountFieldFocused)
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
                                Text(CurrencyFormatter.formatJPY(record.amount))
                            }
                        }
                    }
                }
            }
            .navigationTitle("記録")
            .onAppear {
                DebugLogger.logUIAction("RecordView appeared")
            }
            .sheet(item: $lastSavedRecord) { record in
                if let miniReaction = currentMiniReaction {
                    SaveCompletionPopup(
                        record: record,
                        miniReaction: miniReaction,
                        onComplete: {
                            DebugLogger.logUIAction("Save completion popup closed")
                            closeSaveCompletion()
                        },
                        onEdit: {
                            DebugLogger.logUIAction("Edit selected from popup")
                            // TODO: 編集画面に遷移するロジックを実装
                            closeSaveCompletion()
                        },
                        onContinue: {
                            DebugLogger.logUIAction("Continue input selected from popup")
                            closeSaveCompletion()
                            clearForm()
                        }
                    )
                } else {
                    EmptyView()
                }
            }
            .alert("入力エラー", isPresented: $showingErrorAlert) {
                Button("修正する") {
                    isAmountFieldFocused = true
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
        let trimmedAmount = amount.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let amountValue = Int(trimmedAmount) else {
            showError("金額には数値を入力してください。\n例：1000、500")
            return
        }

        let result = appState.addRecord(
            date: selectedDate,
            category: selectedCategory,
            amount: amountValue,
            memo: memo.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        switch result {
        case .success(let record):
            // コメントとミニリアクションを生成（非Optional）
            let comment = appState.generateComment(for: record)
            let reaction = appState.generateMiniReaction(for: record)
            currentComment = comment
            currentMiniReaction = reaction
            
            // ポリシーベースの表示判定
            let policy = SaveCompletionPolicy()
            if policy.shouldShowPopup(for: record, comment: comment, reaction: reaction) {
                lastSavedRecord = record
                DebugLogger.logUIAction("Opening SaveCompletionPopup")
            } else {
                DebugLogger.logUIAction("SaveCompletionPopup suppressed by policy")
            }
        case .failure(let error):
            showError(error.localizedDescription + "\n\n" + (error.recoverySuggestion ?? ""))
        }
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
    
    /// 保存完了ポップアップを閉じる
    private func closeSaveCompletion() {
        currentComment = nil
        currentMiniReaction = nil
        lastSavedRecord = nil
    }
}

#Preview {
    RecordView()
}
