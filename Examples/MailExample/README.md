# MailExample

An example implementation of a three-column `NavigationSplitView` using UIRouting.

## Implemented features

### Three-column layout
- **Sidebar (left)**: Inbox, Sent, Archive, Starred
- **Content (center)**: mail list
- **Detail (right)**: mail detail

### Four layers of routing

1. **Switch sidebar**: Inbox → Sent, etc.
2. **Select content**: select an email → shown in detail
3. **ContentRoute (navigation within center column)**: push to filter/search views
4. **DetailRoute (navigation within detail column)**: push to sender info/attachments views

### Selection state management
- `SplitViewPresenter.selectedSidebar`: sidebar selection
- `SplitViewPresenter.selectedContent`: email selected in the center column
- Independent `NavigationStack` per column

### Sample data
- Different mail lists per sidebar
- Filtering for starred mail
- Automatic data updates when switching sidebar

## What to learn

1. **Three-column SplitView**: how to use `ThreeColumnSplitViewRouting`
2. **ContentItem**: selectable item in the center column (`Email`)
3. **ContentRoute**: push navigation within the center column
4. **DetailRoute**: push navigation within the detail column
5. **selectedContentBinding**: manage center-column selection via a `Binding`

## How to run

```bash
cd Examples/MailExample
open MailExample.xcodeproj
# Run from Xcode
```

## Comparison: two columns vs three columns

| | 2カラム | 3カラム |
|---|---|---|
| Layout | sidebar + detail | sidebar + list + detail |
| ContentItem | not needed (`Never`) | required (`Email`) |
| ContentRoute | not needed (`Never`) | optional (list navigation) |
| contentView | not needed | required (list view) |
| selectedContent | not used | used (list selection) |

Two-column uses `SplitViewRouting`; three-column uses `ThreeColumnSplitViewRouting`.
