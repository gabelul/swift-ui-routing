# MailExample

UIRoutingの3カラムNavigationSplitView実装例

## 実装機能

### 3カラムレイアウト
- **サイドバー（左）**: 受信箱、送信済み、アーカイブ、スター付き
- **コンテンツ（中央）**: メールリスト
- **詳細（右）**: メール詳細

### 4階層のルーティング

1. **サイドバー切り替え**: 受信箱 → 送信済み など
2. **コンテンツ選択**: メール選択 → 詳細に表示
3. **ContentRoute（中央カラム内ナビゲーション）**: フィルタ・検索ビューへのpush遷移
4. **DetailRoute（詳細カラム内ナビゲーション）**: 送信者情報・添付ファイルへのpush遷移

### 選択状態管理
- `SplitViewPresenter.selectedSidebar`: サイドバー選択
- `SplitViewPresenter.selectedContent`: 中央カラムで選択されたメール
- 各カラム独立したNavigationStack

### サンプルデータ
- サイドバーごとに異なるメール表示
- スター付きメールのフィルタリング
- サイドバー切り替えで自動データ更新

## 学習ポイント

1. **3カラムSplitView**: `ThreeColumnSplitViewRouting`の使い方
2. **ContentItem**: 中央カラムで選択可能なアイテム（Email）
3. **ContentRoute**: 中央カラム内でのpush遷移
4. **DetailRoute**: 詳細カラム内でのpush遷移
5. **selectedContentBinding**: 中央カラムの選択状態をBindingで管理

## 実行方法

```bash
cd Examples/MailExample
open MailExample.xcodeproj
# Xcodeで実行
```

## 比較: 2カラム vs 3カラム

| | 2カラム | 3カラム |
|---|---|---|
| レイアウト | サイドバー + 詳細 | サイドバー + リスト + 詳細 |
| ContentItem | 不要（`Never`） | 必須（`Email`） |
| ContentRoute | 不要（`Never`） | オプション（リスト内ナビゲーション） |
| contentView | 不要 | 必須（リストビュー） |
| selectedContent | 使用しない | 使用（リスト選択） |

2カラムは`SplitViewRouting`、3カラムは`ThreeColumnSplitViewRouting`を使用。
