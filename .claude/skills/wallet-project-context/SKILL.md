---
name: wallet-project-context
description: Use when implementing, modifying, planning, or reviewing ANY feature, screen, widget, provider, repository, or dependency in this Flutter wallet repo — including onboarding, send, receive, swap, history, settings, key handling, balances, gas, or pubspec changes.
---

# Wallet Project Context

Self-custody Flutter wallet on Base mainnet holding **real money**. Wrong code here loses funds, not just renders badly. The project overview is the source of truth for architecture, stack, phase order, and non-negotiable constraints.

## The Rule

**Before writing or changing any code, read [docs/flutter-wallet-plan-overview.md](../../../docs/flutter-wallet-plan-overview.md) in full.**

Then state in your response, before touching code:
1. Which phase (0–6) the work belongs to
2. Which constraints from the overview apply to it
3. Any conflict between the request and the overview — raise it, don't silently resolve it

No exceptions:
- Not for "just a small widget"
- Not for "I read it earlier in this session" — re-read if you have summarized/compacted context
- Not for "this is obviously unrelated to crypto" — theme, routing, and folder layout are specified there too
- Reading the file is cheap. Guessing costs money.

## Hard constraints (still read the overview — this is a reminder, not a replacement)

| Rule | Why |
|---|---|
| `BigInt` for storage/math, `Decimal` for display. **Never `double`, never `.toDouble()`** on amounts | IEEE-754 can't hold 10^18 wei — silent fund loss |
| Read each token's own `decimals`. Never hardcode 18 | USDC on Base is 6 — off by 10^12 |
| Store **mnemonic only**, encrypted, biometric-gated. Derive keys per-use, never persist private keys, never hold them in provider state | Key exfiltration = total loss |
| Never log/print/copy/analytics a mnemonic or private key | Same |
| Pin crypto package versions exactly (`web3dart: 3.0.3`, not `^`). Commit `pubspec.lock` | `blockchain_utils` publisher is unverified |
| `approve` exact amount, never unlimited | Malicious contract drains token |
| Validate EIP-55 checksum on addresses; `eth_call` simulate before sending | Bad address = permanent loss; revert = wasted gas |
| Dev/test on Base Sepolia; mainnet only for Swap and verified flows | Don't burn real funds debugging |
| Never touch a real personal seed phrase | — |
| Every confirm / warning / result is a **bottom sheet**: `showAppConfirmSheet`, `showAppActionSheet`, `AppSheet`. Never `AlertDialog`, `SnackBar`, `showDialog`, or a raw `showModalBottomSheet` in `lib/features/` | A tiny "Delete" label next to "Cancel" is a mis-tap that costs funds; sheets give full-width buttons and one consistent shape |
| Use the existing theme tokens: `context.colors.*`, `context.typo.*`, `AppDimens.*`. **Need a color or font outside the set? Stop and ask before building** | Hardcoded styles drift per screen and block the light theme; hand-built `TextStyle` on amounts drops tabular figures and the balance jitters on every refresh |

Structure and phase order are in the overview — follow its `lib/` layout and don't jump phases (security is Phase 0, not last).

## Checkpoint gate

The BIP39 test-vector + MetaMask address cross-check at the end of Phase 1 is blocking. Do not write or advise funding flows past it without confirming those tests exist and pass.

## Red flags — stop and go read the overview

- About to run `flutter pub add` without checking the stack table
- About to pick a state management / routing / model approach
- Reaching for `double`, `num`, or `toStringAsFixed` on an amount
- Typing `Color(0xFF`, `Colors.`, or a bare `TextStyle(` inside `lib/features/`
- Typing `showDialog`, `AlertDialog`, `SnackBar`, or `showModalBottomSheet` inside `lib/features/` — confirms and notifications go through `showAppConfirmSheet` / `showAppActionSheet` (overview §4.6)
- About to introduce a color or font that isn't already in `lib/app/theme/` — that needs the user's approval first, not a new token invented on the spot
- Creating a folder under `lib/` that isn't in the overview's layout
- Implementing a screen without knowing which phase it's in
- Thinking "the overview probably says something like..."
