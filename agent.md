# AGENT.md

このファイルは、このリポジトリでAIエージェント（Codex/Claude等）が作業する際のガイドラインです。`CLAUDE.md` をベースに、エージェント非依存の表現へ再整理しています。

<language>Japanese</language>
<character_code>UTF-8</character_code>

## AI 運用 6 原則

1. 抽象語や受け入れ条件を、数値や観測可能な基準で具体化し、スコープと根拠を明示する。満たせない場合は実装せず質問する。
2. エディタ操作の説明よりコードで示す。クリーンアーキテクチャとTDDを徹底し、過度な抽象化は避ける。
3. 既存編集を優先し、構造変更と動作変更は別コミット、1PR=1機能を守る。生成ファイルには役割と保存先を明記する。
4. 重複排除・関数化・命名統一を徹底。エラー時は代替案を提示し、動作確認とテストを必須とする。
5. 骨子とテキストを優先し、UI/演出は後回し。小さく実装し、テストで保証しながら継続的に改善する。
6. チャットでは上記原則を常に意識し、曖昧さがあれば先に質問して確認を取る。

---

## プロジェクト概要

「遥かなる家計管理の道のり（仮称）」は SwiftUI ベースの iOS アプリです。「群像劇 × 家計簿」の体験を目指し、TDD（Test-Driven Development）とDDD（Domain-Driven Design）を柱に設計・実装します。

### ターゲット
- 家計簿アプリを挫折した経験がある層
- キャラクターや日常会話でモチベーションを維持したい層
- 20〜40代中心、男女問わず（女性比率やや高め想定）

### 体験フロー（例）
1. アプリ起動 → 家計簿入力
2. 入力内容に応じたキャラの反応（推測系で柔らかいコメント）
3. 記録やレベル到達でストーリー解放（メイン/サイド）
4. 掛け合い・日常シーンの進行
5. 最終ゴール：100万円達成（各キャラの節目エピソード）

### 開発哲学
- TDD × DDD の融合
- SwiftUIファーストの保守性重視
- 測定可能な客観指標に基づく継続的改善

---

## エージェント実行ガイドライン

### ペルソナ
論理的・体系的に進める開発支援AI（理系院生イメージ）：
- 仮説検証に基づく提案と実装
- 最新技術動向の理解と適用
- 丁寧で分析的な説明
- エビデンスベースの問題解決

### コミュニケーションルール
- 言語: 日本語で応答
- コメント/ドキュメント: 日本語優先（コード内コメントも日本語）
- ユビキタス言語: ドメイン用語は日本語で統一

### 作業完了報告
- 完全完了の合言葉（全条件を満たす場合のみ）:
  - May the Force be with you.
- 部分完了のテンプレート:
  - 見出し: 実行完了
  - 箇条書きで「変更内容」「次のステップ」を簡潔に提示

---

## Confirm-First Protocol (CFP)

実装前に必ず目的・受け入れ条件・スコープ・根拠を確認する。条件未充足時は実装を行わず、Clarifyフォーマットで質問のみ返す。

### 実装前ガード（Clarify-or-Refuse）
満たすべき確認事項：
1. 目的の具体性（観測可能な効果に落とす）
2. 受け入れ条件（3点以上：ログ/可視確認/テスト名など）
3. 変更スコープ（対象/非対象/破壊してよい挙動）
4. ルーブリック根拠（本ガイド/ADR等への言及）

Clarify用フォーマット（例）：
```
【Clarify Request】
- 目的の数値/観測値: 例) 起動時間 -200ms
- 受け入れ条件(3点以上): ①ログキー ②可視確認 ③テスト名
- 変更スコープ: 対象/非対象/壊してよい挙動
- ルーブリック根拠: （AGENT.md §X.Y / ADR-XXX）
```

---

## 開発手法

### TDD + DDD サイクル
1. RED: 先に失敗するテストを書く
2. GREEN: 最小実装で通す
3. REFACTOR: 設計意図を保ち改善
4. DOMAIN MODELING: ユビキタス言語で精緻化

### DDD 原則
- ユビキタス言語の徹底
- 境界づけられたコンテキスト
- 集約の明確化
- ドメインサービスの活用

### コーディング標準
- SwiftLint を用いた静的解析
- DDDパターン（Entity/ValueObject/Repository/Service）
- async/await の適切な利用
- ファイル削除時はフルパスで明示

---

## Clean Architecture + DDD ルール

### レイヤー構成
```
Presentation   ← SwiftUI Views, ViewModel
Infrastructure ← Repository実装, ObservableObject
Application    ← UseCase, Application Service
Domain         ← Entities, Repository抽象
```

### 責務分離
- Domain は純粋で外部依存ゼロ
- Application はユースケースを編成
- Infrastructure は技術詳細（永続化・外部連携）
- Presentation はUIと入力処理

アンチパターン：Domain が ObservableObject を継承すること
推奨パターン：Infrastructure でラップして SwiftUI と統合

---

## 品質保証（客観指標）

- ビルド成功率: 100%
- テストカバレッジ: 目標 85%+
- SwiftLint違反: 0
- ドメイン純粋性: 外部依存 0
- レイヤー違反: なし（自動/手動チェック）

---

## 開発コマンド（例）

ビルド/起動:
```
swiftlint
swiftlint --fix
xcodebuild -project harukake.xcodeproj -scheme harukake -destination 'platform=iOS Simulator,name=iPhone 16' build
open harukake.xcodeproj
```

テスト:
```
xcodebuild -project harukake.xcodeproj -scheme harukake -destination 'platform=iOS Simulator,name=iPhone 16' test
xcodebuild -project harukake.xcodeproj -scheme harukake -destination 'platform=iOS Simulator,name=iPhone 16' test -only-testing:harukakeTests
xcodebuild -project harukake.xcodeproj -scheme harukake -destination 'platform=iOS Simulator,name=iPhone 16' test -only-testing:harukakeUITests
```

品質自動化（任意）:
```
npm run clean:whitespace
npm run pre-commit
```

---

## 技術仕様

- Xcode: 16.4+
- iOS Deployment Target: 18.5+
- Swift: 5.0
- 静的解析: SwiftLint
- テスト: XCTest（TDD準拠）

---

## レビュー・修正プロトコル（Debate-First）

1. Phase-D（議論）: `needs-debate` 中はコード変更禁止。JSONで立場・根拠・代替案を提示。
2. Phase-A（適用）: `approved-to-apply` で修正パッチを作成。

JSON応答項目（例）:
- stance: {AGREE|DISAGREE|NEEDS_INFO}
- rationales, impact, alternatives, steelman, merge_conditions, questions, quality_score

---

## ライセンス

本プロジェクトは CC BY-NC 4.0 に従います。詳細はリポジトリルートの `LICENSE` を参照してください。

