# 遥かなる家計管理の道のり（仮称）

## 概要

「群像劇 × 家計簿」という全く新しいジャンルのアプリ。
毎日の家計簿入力をトリガーに、5人のキャラクターによる日常ストーリーや掛け合いが展開される。
節約・家計管理を“義務”から“楽しみ”に変える、プロセカ・バンドリ・ブルアカのUXを踏襲した体験設計。

## ターゲット

*   家計簿アプリを挫折した経験がある層
*   キャラクターや日常会話でモチベを維持したい層
*   20〜40代中心、男女問わず（女性比率やや高め想定）

## 世界観・キャラクター

**舞台**：節約コミュニティ「カケイ部」

**メンバー**：
*   **佐久間 誠**（リーダー・既婚男性、浪費家→節約初心者）
*   **中原 大地**（要領悪い節約初心者・独身、親孝行のために貯金）
*   **守銭寺 ひかり**（超ケチ・FIRE志向）
*   **華野 れいな**（元浪費家・婚約中）
*   **本城 まゆ**（バランス型・起業失敗で借金返済中）

## 体験フロー

1.  アプリ起動 → 家計簿入力
2.  入力内容に応じたキャラの反応（コメントは推測系で柔らかく）
3.  一定の記録やレベル到達でストーリー解放（メイン＆サイド）
4.  キャラ同士の掛け合い・日常シーンが進行
5.  最終ゴール：100万円達成（各キャラの節目エピソード）

## 差別化ポイント

*   群像劇構造（キャラ間の掛け合い・関係性の変化）
*   プレイヤー恋愛要素ほぼゼロ、男女どちらも親しめる
*   家計簿入力がストーリー進行のトリガー
*   記録へのキャラ反応＋キャラ自ら記録投稿する演出
*   広告・課金UIゼロ、支援はクレジット画面のみ

## UI構成

*   **下部ナビ**：記録／分析／ストーリー
*   **ホーム画面**：5人の立ち絵、左上にグループチャット・ミッション
*   **ミッション**：ログイン・家計簿入力（デイリー）、週7回記録（ウィークリー）
*   **レベル・称号システム**（上限100）
*   節約ジュエルで新ストーリー開放

## 収益構造

*   アプリ内収益ゼロ（広告も課金もなし）
*   クレジット画面に支援リンク＋グッズ販売導線
*   **グッズ第1弾**：全員集合エコバッグ（オンデマンド印刷、支援込み価格3,500〜4,000円）

---

## 最小MVP実装仕様

### 画面ラフ（テキストワイヤフレーム）

#### 1. 記録タブ
```
┌─────────────────────┐
│ 【記録】         今日 │
├─────────────────────┤
│ 日付: [DatePicker]   │
│ カテゴリ: [食費 ▼]   │
│ 金額: [______] 円    │
│ メモ: [__________]   │
│                     │
│     [保存]          │
└─────────────────────┘
↓ 保存後
┌─────────────────────┐
│ 💬キャラクターコメント │
│ 「外食かな？楽しそう」│
│     [閉じる]        │
└─────────────────────┘
```

#### 2. 分析タブ
```
┌─────────────────────┐
│ 【分析】    2025年1月 │
├─────────────────────┤
│ ▲カテゴリ別合計      │
│ ┌─────────────────┐ │
│ │  [棒グラフ]      │ │
│ │  食費:25000円    │ │
│ │  家賃:80000円    │ │
│ └─────────────────┘ │
│                     │
│ 💰前月比             │
│ 食費: +2000円       │
│ 「今月は外食多め？」 │
└─────────────────────┘
```

#### 3. ストーリータブ
```
┌─────────────────────┐
│ 【ストーリー】       │
├─────────────────────┤
│ ▲メイン Lv.5/100    │
│ ✅第1章「始まり」    │
│ 🔒第2章 Lv.5で解放  │
│                     │
│ ▲サイド (ジュエル:5) │
│ 👤ひかり             │
│ ✅節約の基本         │
│ 🔒恋愛相談 (💎3)     │
│                     │
│ 👤れいな             │
│ 🔒婚約の話 (💎3)     │
└─────────────────────┘
```

#### 4. 設定タブ
```
┌─────────────────────┐
│ 【設定】             │
├─────────────────────┤
│ 👤プロフィール       │
│ ニックネーム: [田中] │
│                     │
│ 💾データ             │
│ [バックアップ]       │
│ [復元]              │
│                     │
│ ℹ️ その他             │
│ [クレジット]         │
│ [アプリ情報]         │
└─────────────────────┘
```

### 主要クラス・関数一覧

#### Domain層（ビジネスルール）
```swift
// Models/Domain/
enum Category: String, Codable, CaseIterable
struct RecordItem: Identifiable, Codable
enum CharacterId: String, Codable, CaseIterable
struct Progress: Codable
struct MissionState: Codable

// Domain Services
class ProgressCalculator {
    static func calculateRequiredXP(level: Int) -> Int
    static func calculateLevel(exp: Int) -> Int
}

class MissionValidator {
    func checkDailyCompletion(_ state: MissionState) -> Bool
    func shouldResetDaily(_ state: MissionState) -> Bool
}
```

#### Application層（ユースケース・エンジン）
```swift
// Engines/
class CommentEngine {
    func generateComment(for item: RecordItem, lastMonth: Int?) -> String
    func generateFixedCostComment(category: Category, diff: FixedCostDiff) -> String
}

class ProgressEngine {
    func addExperience(_ amount: Int, to progress: inout Progress)
    func addJewels(_ amount: Int, to progress: inout Progress)
}

class FixedCostEngine {
    func generateFixedCosts(for month: Date, rules: [FixedCostRule]) -> [RecordItem]
    func compareWithLastMonth(category: Category, amount: Int, records: [RecordItem]) -> FixedCostDiff
}

class MissionEngine {
    func updateDaily(state: inout MissionState)
    func resetIfNeeded(state: inout MissionState)
}
```

#### Infrastructure層（技術詳細）
```swift
// Stores/
class PersistenceService {
    func loadAppState() throws -> AppState
    func saveAppState(_ state: AppState) throws
    func exportJSON() throws -> Data
    func importJSON(_ data: Data) throws -> AppState
}

@MainActor class AppState: ObservableObject {
    @Published var records: [RecordItem]
    @Published var progress: Progress
    @Published var missions: MissionState
    
    func addRecord(_ item: RecordItem)
    func ensureFixedCosts()
    func updateMissions()
}
```

#### Presentation層（UI）
```swift
// Views/Tabs/
struct RecordView: View
struct AnalyticsView: View
struct StoryView: View
struct SettingsView: View

// Views/Shared/
struct CommentModal: View
struct StoryReaderView: View

// MainApp
struct HarukakeApp: App
struct ContentView: View  // TabView container
```

### 初期データ構成
- **キャラクター**: 5人（hikari, reina, mayu, makoto, daichi）
- **固定費ルール**: 家賃(8日/80000), 光熱(27日/6000), 通信(25日/4000)
- **メインストーリー**: 3章（Lv1, Lv5, Lv10で解放）
- **サイドストーリー**: 各キャラ2話（ジュエル3/5で解放）

---

## ホーム画面レイヤー構成

### 4層レイヤー構造

```
┌─────────────────────────────────────────────┐
│ 4. UI オーバーレイ                            │
│ ┌─────────────────┐ ┌─────────────────┐      │
│ │ TopStatusBar    │ │ RightUtilities  │      │
│ │ (Lv/支出/貯金)   │ │ (Help/Settings) │      │
│ └─────────────────┘ └─────────────────┘      │
│ ┌─────────────────┐                          │
│ │ LeftShortcuts   │                          │
│ │ (Msg/Mission)   │                          │
│ └─────────────────┘                          │
│ ┌─────────────────────────────────────────┐  │
│ │            BottomMenuBar                │  │
│ │     [記録][分析][ストーリー][設定]        │  │
│ └─────────────────────────────────────────┘  │
├─────────────────────────────────────────────┤
│ 3. 立ち絵レイヤー (CharacterLayer)             │
│    将来のLive2D対応想定                       │
├─────────────────────────────────────────────┤
│ 2. 背景CG (CGBackgroundView)                 │
│    時間帯・章進行での自動切り替え               │
├─────────────────────────────────────────────┤
│ 1. ベース背景                                │
│    フォールバック用グラデーション               │
└─────────────────────────────────────────────┘
```

### アセット命名規則

#### 背景CG画像
```
Asset Catalog: harukake/Assets.xcassets/

cg_home_default.imageset/     # 初期・デフォルト背景
  ├─ cg_home_default.png      # 1x (640×360)
  ├─ cg_home_default@2x.png   # 2x (1280×720)
  └─ cg_home_default@3x.png   # 3x (1920×1080)

# 時間帯差分 (将来実装)
cg_home_day.imageset/         # 昼間背景 (6:00-17:59)
cg_home_evening.imageset/     # 夕方背景 (18:00-21:59)  
cg_home_night.imageset/       # 夜間背景 (22:00-5:59)

# 章進行差分 (将来実装)
cg_home_chapter1.imageset/    # 第1章解放時
cg_home_chapter2.imageset/    # 第2章解放時
cg_home_chapter3.imageset/    # 第3章解放時
```

#### 推奨画像仕様
- **アスペクト比**: 16:9 (横長)
- **最小解像度**: 
  - 1x: 640×360px
  - 2x: 1280×720px
  - 3x: 1920×1080px以上
- **フォーマット**: PNG (透明度不要) または JPG
- **構図**: 重要な被写体は中央〜右寄りに配置（左側にUIが重なる）
- **明度**: UI文字の可読性を考慮し、上下20%エリアは暗めに調整

### アーキテクチャマッピング

```
Presentation層/
├─ Views/
│  ├─ HomeView.swift                    # メイン画面・4層構造
│  └─ Components/
│     ├─ CGBackgroundView.swift         # 背景CG表示
│     ├─ TopStatusBar.swift             # 上部ステータス
│     ├─ LeftShortcuts.swift            # 左側ショートカット
│     ├─ RightUtilities.swift           # 右上ユーティリティ
│     └─ BottomMenuBar.swift            # 下部メニュー

Application層/
└─ Services/
   └─ CGBackgroundController.swift      # CG切り替え制御
```

## ライセンス

このプロジェクトは **Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)** の下でライセンスされています。

詳細はリポジトリルートの `LICENSE` ファイルを参照してください。
