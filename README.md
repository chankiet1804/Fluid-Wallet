# fluid_wallet

A new Flutter project.

## Running

API keys come from `env.json` at the repo root — never from a default in code, and
never committed (it is in `.gitignore`). Create it once:

```json
{
  "ALCHEMY_API_KEY": "your-alchemy-key",
  "COINGECKO_API_KEY": ""
}
```

`COINGECKO_API_KEY` may stay empty; the free tier works without one. Then run:

```
flutter run --dart-define-from-file=env.json
```

In VS Code, use the **fluid_wallet (env)** launch configuration, which passes the
same flag.

Running without the flag does not crash — the portfolio degrades honestly to
"N networks are unavailable" with a lower-bound total. If you see that banner
with every network listed, the key is missing.

On the Alchemy dashboard, restrict the key to this app's bundle ID / package name
and set a spend cap. A key inside a shipped mobile binary is extractable.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
