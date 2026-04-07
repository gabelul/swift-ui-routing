# TodoExample

A Todo app demonstrating the core features of UIRouting.

## Implemented features

### Navigation
- Navigate to a todo detail screen
- Navigate to a settings screen
- Back navigation

### Sheet
- Add-todo modal
- Filter settings modal

### Alert
- Delete confirmation alert (independent for Navigation and Sheet)
- Error alert

### TabView
- Independent `NavigationStack` per tab
- Cross-tab navigation (switch tabs + navigate)
- Type-safe tab management

### FullScreenCover & CustomHeightSheet
- Full-screen modals (camera, note editor)
- Custom-height sheets (category picker, quick add)

## What to learn

1. **Core patterns**: basic usage of Navigation, Sheet, and Alert
2. **Type safety**: static member lookup via `@Environment(.router(AppRoute.self))`
3. **Context separation**: independent alert management for Navigation vs Sheet
4. **TabView integration**: routing in tab-based apps
5. **Modal management**: patterns for different presentation styles

## How to run

```bash
cd Examples/TodoExample
open TodoExample.xcodeproj
# Run from Xcode
```
