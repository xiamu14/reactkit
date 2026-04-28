# Swift Native macOS Plan

## Summary

This document describes a simplified native macOS direction for Reactotron focused on AI-assisted React Native debugging.

The goal is not to replace the current desktop app feature-for-feature. The goal is to build a lighter desktop tool for code agents that:

- receives React Native runtime data
- stores a recent in-memory event buffer
- exposes the data through MCP
- provides a minimal native log viewer with search

The recommended first implementation is a **half-native** architecture:

- **Swift native macOS app** for the desktop UI and app lifecycle
- **small embedded Node backend** for runtime ingestion and MCP

This keeps the first release focused, lowers delivery risk, and allows us to reuse the most valuable existing backend logic while removing the Electron shell and most of the current UI surface.

## Product Positioning

This product should be positioned as a lightweight React Native AI debug tool for code agents, not as a full replacement for the current general-purpose Reactotron desktop application.

### Core user promise

- Capture runtime signals from a React Native app.
- Keep recent events available locally.
- Let a code agent inspect those events through MCP.
- Let a human quickly view and search logs in a native desktop UI.

### Non-goals for v1

- feature parity with Electron Reactotron
- advanced timeline cards and rich visualizations
- state subscriptions UI
- overlay tooling
- Android device management tooling
- release/update infrastructure parity
- multi-window workflows
- export/import and historical archives

## Why Swift Native

The current Electron app carries two kinds of cost:

1. platform shell cost
2. broad legacy feature surface

Moving to native Swift addresses the shell cost directly and gives us a better foundation for a smaller, more focused product. Since the new product scope is intentionally reduced, we do not need to bring over the old UI architecture.

SwiftUI is a good fit for the new desktop surface because the new UI can be intentionally simple:

- app/session status
- connected app list
- log/event stream
- search/filter controls
- MCP status

## Recommended Architecture

## High-level shape

The recommended first release is:

1. Native macOS app in Swift/SwiftUI
2. Embedded local backend process using Node
3. Local process communication between Swift and the backend
4. MCP served by the backend

This gives us a native app without forcing an immediate rewrite of the runtime ingestion and MCP layers.

## Responsibilities split

### Swift app responsibilities

- app lifecycle
- native windowing
- native UI
- backend process start/stop supervision
- status display
- log viewing and search
- user settings for ports and limits

### Embedded Node backend responsibilities

- receive Reactotron websocket traffic from React Native apps
- maintain current connection state
- maintain a bounded recent event buffer
- expose MCP tools/resources
- expose a small local API for the Swift app

## Existing Code To Reuse First

The most valuable reusable pieces are already isolated enough to serve as the first backend core.

### Direct reuse candidates

- `lib/reactotron-core-server`
- `lib/reactotron-mcp`

These contain the important runtime backbone:

- websocket ingestion
- connection lifecycle
- command/event flow
- MCP server creation
- MCP resources and tools

### Logic to use as a reference or extract

- `apps/reactotron-app/src/renderer/contexts/Standalone/useStandalone.ts`
- `apps/reactotron-app/src/renderer/contexts/Standalone/index.tsx`

These contain useful product logic for:

- connection selection
- command buffering per client
- clear/reset behavior
- MCP start/stop state

### Do not carry forward as-is

- Electron main process code
- current renderer routing and page structure
- existing advanced UI pages
- Android utility IPC
- overlay tooling
- menu-specific Electron behavior

## Backend Extraction Plan

The new backend should become a small standalone service layer inside the repository.

Suggested package shape:

- `apps/reactotron-native-backend` or `lib/reactotron-native-backend`

It should wrap existing reusable modules and provide a product-specific API for the Swift app.

### Backend v1 responsibilities

- start Reactotron websocket server
- accept app connections on configured port
- maintain in-memory recent events
- provide read-only queries for the Swift app
- start MCP on configured port
- report health and status

### Suggested local API for Swift

Minimum API:

- `GET /health`
- `GET /status`
- `GET /connections`
- `GET /logs?clientId=...&search=...&limit=...`
- `POST /clear`
- `GET /mcp/status`

Optional but useful:

- local websocket or SSE stream for live event updates

## Native App Scope

The native app should stay intentionally small in v1.

### Required UI

- app title/status area
- backend running state
- MCP running state
- connected app list
- selected app log list
- search input
- clear logs action

### Nice-to-have but not required for v1

- basic event type filter
- pause auto-scroll
- copy selected log row
- simple preferences screen

### Excluded from v1

- advanced timeline command renderers
- screenshots/image previews
- deep state inspection views
- custom command execution UI
- benchmarks UI
- network inspector UI
- storage-specific pages

## Delivery Phases

## Phase 0: Define the reduced product

Deliverables:

- final v1 scope
- backend contract list
- success metrics

Completion criteria:

- team agrees on the exact v1 experience
- team agrees that Electron parity is not a goal

## Phase 1: Extract and run the backend outside Electron

Deliverables:

- backend package that starts independently
- websocket ingestion working
- MCP running independently
- local status/query API available

Completion criteria:

- backend can be started without Electron
- React Native app can connect and send events
- MCP can read recent events

## Phase 2: Build the native Swift shell

Deliverables:

- SwiftUI desktop app
- backend process supervision
- status and connection list
- basic log viewer

Completion criteria:

- native app launches backend
- native app shows connection presence
- native app shows incoming logs

## Phase 3: Add search and usability basics

Deliverables:

- search/filter
- clear logs
- auto-refresh/live updates
- simple settings

Completion criteria:

- user can quickly inspect a single app session
- user can search for log text and key event fields

## Phase 4: Validate the code-agent workflow

Deliverables:

- MCP tested against target agent workflow
- prompt examples or usage notes
- event volume guardrails

Completion criteria:

- agent can consistently read relevant runtime context
- MCP responses remain small and useful

## Risks

## Biggest product risk

The biggest risk is uncontrolled scope growth. If we reintroduce old Reactotron features too early, the new native app will inherit the same complexity we are trying to remove.

## Biggest technical risks

### 1. Backend extraction complexity

Even though the server and MCP pieces are already separated, some product logic still lives in the current app layer. We should expect a small amount of reshaping work before the backend feels clean.

### 2. Event volume and UI responsiveness

React Native logging can become noisy quickly. We need bounded buffers, search constraints, and careful UI update behavior from the start.

### 3. MCP output control

The MCP layer must stay intentionally small and query-oriented. If it becomes a raw dump path, it will be less useful for agents and more expensive to operate.

### 4. Process management

The Swift app must reliably start, stop, and observe the backend process. This is not a hard problem, but it should be treated as a first-class product concern.

## Why Not Rewrite Everything In Swift First

A full Swift rewrite is possible, but it is not the best first move.

Reasons:

- it lengthens time to first useful release
- it forces a rewrite of mature ingestion behavior immediately
- it adds avoidable risk to MCP delivery
- it creates more unknowns at once than necessary

The half-native path gets most of the product benefit early:

- native shell
- lighter desktop app
- smaller UI scope
- retained backend maturity

Later, if the backend becomes a limiting factor, we can replace pieces incrementally.

## Success Criteria

The project should be considered successful when all of the following are true:

- native macOS app starts quickly and feels materially lighter than the Electron app
- a React Native app can connect and stream runtime events
- recent logs can be viewed and searched in the native UI
- MCP exposes the runtime context in a way a code agent can actually use
- the first release remains intentionally small and does not chase old Reactotron parity

## Recommended Immediate Next Steps

1. Confirm v1 product scope in writing.
2. Extract a standalone backend package around `reactotron-core-server` and `reactotron-mcp`.
3. Add a thin local API for the native UI.
4. Build a minimal SwiftUI shell around connection list, log list, and search.
5. Validate the MCP workflow with a real React Native debugging scenario before adding more UI.
