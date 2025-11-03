# Pleasetomorrow

**明日の自分に頼む、タスク管理アプリ**

「今日できないことは、明日の自分に頼もう」をコンセプトにした、セルフマネジメント型のタスク管理アプリケーションです。

---

## コンセプト

このアプリは、「未来の自分への手紙」というメタファーを使った、ユニークなタスク管理システムです。

- **Tomorrow View（明日の自分へ）**: 明日の自分に依頼したいタスクを書く
- **Today View（今日やること）**: 昨日の自分から依頼されたタスクを完了する

「頼んだ！明日のジブン！」という合言葉で、自分自身への約束を楽しく、責任を持って実行できるようデザインされています。

---

## 主な機能

### Tomorrow View（明日への依頼）
- タスクの追加（最大30文字）
- タスクの編集・削除
- カラフルなカードレイアウト
- モチベーションメッセージ表示

### Today View（今日の実行）
- 昨日依頼したタスクの表示
- チェックボックスでの完了管理
- 進捗バーと達成カウンター
- 全タスク完了時の達成バッジ表示

### 自動日付管理
- 日付が変わると自動的にタスクが切り替わります
- 昨日の「Tomorrow」が今日の「Today」に
- 古いタスクは自動クリーンアップ

---

## 技術スタック

### フレームワーク
- **Flutter** - クロスプラットフォーム開発

### 状態管理
- **Provider (6.1.1)** - ChangeNotifierパターンによる状態管理

### データベース
- **SQLite (sqflite 2.3.0)** - ローカルデータ永続化
- タスクのCRUD操作を実装

### 主要パッケージ
| パッケージ | バージョン | 用途 |
|-----------|----------|------|
| provider | 6.1.1 | 状態管理 |
| sqflite | 2.3.0 | SQLiteデータベース |
| path_provider | 2.1.1 | ファイルパス管理 |
| intl | 0.19.0 | 日付フォーマット（日本語対応） |
| shared_preferences | 2.2.2 | 永続化ストレージ |
| flutter_staggered_grid_view | 0.7.0 | 動的グリッドレイアウト |

---

## 画面構成

### HomeScreen
- メインコンテナ
- タブナビゲーション（Tomorrow / Today）
- アニメーション付きページ遷移
- グラデーション背景

### TomorrowView
- タスク入力フィールド
- マルチカラーのタスクカード
- インライン編集機能
- 削除機能

### TodayView
- 昨日のタスク表示
- 完了チェック機能
- 進捗表示（完了数/総数）
- 達成時の祝福アニメーション

---

## プロジェクト構造

```
lib/
├── main.dart                 # アプリエントリーポイント
├── screens/
│   ├── home_screen.dart      # ナビゲーションコンテナ
│   ├── today_view.dart       # 今日のタスク画面
│   └── tomorrow_view.dart    # 明日への依頼画面
├── models/
│   └── task.dart             # タスクデータモデル
├── database/
│   └── database_helper.dart  # SQLite操作
├── providers/
│   └── task_provider.dart    # 状態管理
└── widgets/
    ├── task_card.dart        # タスクカードコンポーネント
    └── tip_bubble.dart       # ヒントメッセージコンポーネント
```

---

## セットアップ

### 前提条件
- Flutter SDK (最新安定版)
- Android Studio / Xcode（エミュレータ用）

### インストール

1. リポジトリをクローン
```bash
git clone <repository-url>
cd flutter_sample
```

2. 依存パッケージをインストール
```bash
flutter pub get
```

3. アプリを実行
```bash
flutter run
```

または、VSCodeのコマンドを使用：
```bash
/flutter-run
```

---

## 使い方

1. **Tomorrow Viewでタスクを追加**
   - 入力欄に明日やりたいことを書く（30文字以内）
   - 「頼んだ！明日のジブン！」で追加

2. **翌日、Today Viewで確認**
   - 昨日追加したタスクが自動的に表示される
   - タスクをタップしてチェック

3. **全タスク完了で達成感**
   - すべてのタスクを完了すると達成バッジが表示されます

---

## 特徴的な実装

- **日付変更検知**: SharedPreferencesを使った自動日付管理
- **データ永続化**: SQLiteによるローカルストレージ
- **レスポンシブUI**: 動的グリッドレイアウトと回転エフェクト
- **アニメーション**: スムーズな画面遷移と達成時のバウンスアニメーション
- **関心の分離**: Tomorrow（CRUD操作）とToday（読み取り+完了トグル）で機能を分離

---

## ライセンス

このプロジェクトはサンプルアプリケーションです。

---

## 開発者向けメモ

### データベーススキーマ
```sql
CREATE TABLE tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  text TEXT NOT NULL,
  completed INTEGER NOT NULL DEFAULT 0,
  date TEXT NOT NULL,
  created_at TEXT NOT NULL
)
```

### 日付フォーマット
- `YYYY-MM-DD` 形式で統一
- `ja_JP` ロケールで日本語日付表示

### 色彩設計
- **Tomorrow View**: 暖色系（オレンジ、黄色、ピンク）- 計画・期待
- **Today View**: 寒色系（青系）- 実行・集中

---

**頼んだ！明日のジブン！** 🌸
