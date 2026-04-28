# Design

## Visual Direction

Use reference image 1 as the visual source: warm off-white canvas, soft white rounded panels, black primary text, muted gray secondary text, and a coral-red accent. The result should feel like a polished macOS productivity tool rather than the original utility UI.

## Scene

A React Native developer is debugging on a MacBook or external monitor in a bright workspace, with an AI code agent open nearby. The app should be light, calm, and easy to scan for several minutes at a time.

## Color Tokens

- Canvas: `oklch(0.972 0.006 65)` (`#F7F6F3` approximate)
- Surface: `oklch(0.992 0.004 65)` (`#FEFDFC` approximate)
- Surface soft: `oklch(0.955 0.005 65)` (`#F0EFEC` approximate)
- Border: `oklch(0.895 0.006 65)` (`#DEDCD7` approximate)
- Text primary: `oklch(0.135 0.006 65)` (`#12110F` approximate)
- Text secondary: `oklch(0.56 0.006 65)` (`#85827C` approximate)
- Text muted: `oklch(0.72 0.006 65)` (`#B4B1AB` approximate)
- Accent: `oklch(0.655 0.155 35)` (`#E85F45` approximate)
- Accent hover: `oklch(0.61 0.16 35)` (`#D94E38` approximate)
- Accent soft: `oklch(0.925 0.04 35)` (`#F5DDD7` approximate)
- Success: `oklch(0.62 0.13 145)` (`#2F9E64` approximate)
- Warning: `oklch(0.72 0.14 75)` (`#D99A22` approximate)

## Typography

Use SF Pro / system font for the SwiftUI app. Avoid using monospaced type globally; reserve monospaced digits or code text for timestamps, ports, and log payloads.

- App title: 24 pt, semibold
- Section title: 18 pt, semibold
- Card title: 16 pt, semibold
- Body: 14 pt, regular
- Secondary body: 13 pt, regular
- Caption: 12 pt, regular
- Log timestamp and payload: 13 pt, monospaced
- Large empty-state headline: 34 pt, semibold

## Layout

- Window target: 1440 x 960 minimum design canvas
- Outer padding: 32 px
- Header height: 112 px
- Sidebar width: 88 px collapsed, 260 px expanded
- Main grid gap: 20 px
- Panel padding: 24 px
- Compact panel padding: 16 px
- Log row height: 72 px minimum
- Status footer height: 44 px

## Radius And Borders

- Window/content band radius: 28 px
- Main panels: 26 px
- Small cards: 22 px
- Search fields and pill controls: 999 px
- Icon buttons: circular, 56 px
- Primary action button: height 56 px, radius 28 px
- Standard border: 1 px using Border token

## Component Notes

- Header should contain product identity, backend/MCP status, search, and main actions.
- Sidebar should use icon buttons and concise labels, but be visually softer and more spacious than the original reference rail.
- Timeline should preserve the original functional columns: delta time, timestamp, type, summary, expansion affordance.
- Empty states should use the large, calm reference style, but speak directly to ReactKit: no connected app, no activity, or MCP stopped.
- Keep controls familiar: search field, filter button, clear button, pause auto-scroll toggle, connection selector.

## Motion

Use short 150-220 ms ease-out transitions for selection, hover, search reveal, and row expansion. Do not animate layout-heavy log streams beyond subtle opacity/offset on inserted rows.
