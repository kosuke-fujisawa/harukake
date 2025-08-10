# ハルカケ｜テクニカルアーキテクチャ設計書

このドキュメントは、アプリ「ハルカケ」の技術的な設計、アーキテクチャ、実装方針を定義します。

## 1. ドメインモデル（Swift）
```swift
enum Category: String, Codable, CaseIterable { case 食費, 日用品, 交通, 娯楽, 通信, 光熱, 家賃, その他 }

struct RecordItem: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var category: Category
    var amount: Int
    var memo: String?
    var isFixed: Bool = false
}

enum CharacterId: String, Codable, CaseIterable { case hikari, reina, mayu, makoto, daichi }

struct StoryNode: Identifiable, Codable {
    enum Kind: String, Codable { case main, side }
    enum Unlock: Codable { case level(Int), jewel(Int) }
    var id: String
    var title: String
    var paragraphs: [String]
    var kind: Kind
    var unlock: Unlock
    var character: CharacterId?
}

struct MissionState: Codable {
    struct Daily: Codable { var login: Bool; var input: Bool; var lastReset: Date }
    struct Weekly: Codable { var inputsThisWeek: Int; var weekStart: Date }
    var daily: Daily
    var weekly: Weekly
}

struct Progress: Codable {
    var level: Int
    var exp: Int
    var jewels: Int
    var readStories: Set<String>
    var titles: [String]
}

struct FixedCostRule: Codable {
    var category: Category // 家賃/光熱/通信
    var dayOfMonth: Int
    var amount: Int
}
```

## 2. アーキテクチャ
- **UI**: SwiftUI（iOS16+）。横画面固定。
- **状態管理**: `AppState` (ObservableObject) に `records/progress/missions/stories/rules` を集約。
- **永続化**: JSON + `FileManager`（後に SwiftData/Core Data に移行可）。
- **ロジック分離（エンジン）**:
    - `CommentEngine`（推測コメント選択）
    - `FixedCostEngine`（固定費生成/比較）
    - `ProgressEngine`（XP/レベル/ジュエル）
    - `MissionEngine`（デイリー/ウィークリー）
- **ビュー構成**:
```
HomeView (ZStack)
 ├ CGBackgroundView + Controller
 ├ CharacterLayerView
 ├ TopStatusBar / LeftShortcuts / RightUtilities
 ├ CommentOverlay
 └ BottomMenuBar → RecordSheet / AnalyticsSheet / StorySheet / ArchiveSheet / Settings
```

## 3. ディレクトリ構造
```
HarukakeApp.swift
Models/
Stores/   (AppState, Persistence)
Engines/  (CommentEngine, FixedCostEngine, ProgressEngine, MissionEngine)
Views/
  Home/
    HomeView.swift
    TopStatusBar.swift
    LeftShortcuts.swift
    RightUtilities.swift
    BottomMenuBar.swift
    CommentOverlay.swift
  Sheets/
    RecordSheet.swift
    AnalyticsSheet.swift
    StorySheet.swift
    ArchiveSheet.swift
    SettingsSheet.swift
Assets/
  cg_home_default.png
  chars/*.png
Data/
  stories.json (ダミー)
```

## 4. 非機能要件
- **パフォーマンス**: ホーム60fps目標。CG切替0.25sフェード。
- **アクセシビリティ**: 背景は読み上げ対象外／主要数値はVoiceOver名付け。
- **ローカライズ**: 日本語のみ（文字詰め前提）。
- **プライバシー**: 外部送信なし。広告/SDKなし。

## 5. QA観点とテスト
- **ユニット（XCTest）**:
    - XP計算：境界（Lv1→2）
    - ミッション：日跨ぎ0時JST、週初（Mon）
    - 固定費生成：当月初回のみ、前月比判定
- **UI回帰**:
    - 横固定の維持、起動直後の帧落ちなし
    - 保存→コメント→すぐ分析を開閉してもクラッシュしない
    - JSON入出力の往復
- **可用性**:
    - mini/Pro Max/iPad横の可読性
    - VoiceOver：上帯数値読み上げ、背景は除外

## 6. 今後の拡張（ポストMVP）
- Live2D化/軽アニメ
- 背景CGの時間帯自動切替
- ストーリー量追加、称号演出
- iPad 2ペイン本格対応（履歴＋詳細）
- 端末間同期（SwiftData＋CloudKit検討）
