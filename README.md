# ReactKit

ReactKit is a native macOS debugger shell for React Native apps. It currently uses the Reactotron protocol packages as the runtime compatibility layer, kept in `packages/reactotron`.

## Requirements

- macOS 13 or newer
- Xcode command line tools
- Node.js 18 or newer
- Corepack enabled for Yarn

## First setup on a new machine

From the repository root:

```bash
npm run setup
npm run start
```

`swift run ReactKit` starts the native macOS app. The app automatically starts the local ReactKit backend, which listens for app events on runtime port `9091`, starts the local API on `3901`, and starts MCP on `4567`.

## Running again after setup

```bash
npm run start
```

If `packages/reactotron` changes, rebuild it before launching ReactKit again:

```bash
npm run build:reactotron
```

## React Native app setup

Configure your React Native app to use runtime port `9091`.

```ts
Reactotron.configure({
  name: "YourApp",
  port: 9091,
})
```

For Android devices or emulators, reverse the port before launching the app:

```bash
adb reverse tcp:9091 tcp:9091
```

ReactKit is not packaged yet. For now, start it from the repository root with `npm run start`.

## MCP usage

ReactKit starts its MCP server automatically with the desktop app. The default MCP endpoint is:

```txt
http://127.0.0.1:4567/mcp
```

Register it in Codex as `reactkit`. After it is available in a Codex session, use the ReactKit MCP tools to inspect runtime data without calling the HTTP endpoint directly.

Common MCP queries:

```json
{
  "tool": "query_logs",
  "arguments": {
    "prefix": "specialPlans",
    "subprefix": "sync",
    "limit": 20
  }
}
```

```json
{
  "tool": "query_network",
  "arguments": {
    "url": "aiv-vip-plans",
    "limit": 20
  }
}
```

Useful tools exposed by the MCP server include:

- `query_logs`: read filtered timeline logs by prefix, subprefix, keyword, and time range.
- `query_network`: read filtered API/network events by URL, method, headers, and time range.
- `query_storage`: inspect AsyncStorage mutation events.
- `request_state` and `request_state_keys`: inspect Redux or MST state when the app plugin is configured.
- `clear_timeline`: clear timeline events from the desktop app and MCP buffer.

If Codex does not show the ReactKit MCP tools after changing the MCP configuration, restart the Codex session so the tool list refreshes.
