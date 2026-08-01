# Plan: Flutter Crypto Wallet (Base mainnet, self-custody)

## Context

Bạn muốn làm một app ví crypto cá nhân bằng Flutter, lấy ý tưởng UX từ file Figma "Great UX/UI crypto wallet App" (file này chỉ là ảnh raster, không dev handoff được — dùng làm bản đồ UX, không phải nguồn token/component).

Phạm vi: 6 nhóm màn — **Get start, Send, Receive, Swap, History, Settings**.

Quyết định đã chốt:

| Hạng mục | Lựa chọn |
|---|---|
| Chain | EVM only — **Base mainnet (chainId 8453)** |
| Custody | Self-custody, tự sinh & giữ seed phrase, ký local |
| Vốn | Tiền thật, quy mô nhỏ (~$5–10) |
| Swap | Aggregator thật (0x Swap API v2) |
| Kiến trúc | Riverpod + go_router + freezed |

Lý do chọn Base mainnet thay vì testnet: 0x và LI.FI **không hỗ trợ testnet** ([0x supported chains](https://docs.0x.org/docs/introduction/supported-chains) chỉ có 20 chain mainnet; [LI.FI docs](https://docs.li.fi/li.fi-api/li.fi-api/requesting-a-quote/testing-your-integration): *"We no longer support testnets and advise running your test transactions on mainnets"*). Base có gas vài cent nên test trên mainnet là khả thi.

**Hệ quả bắt buộc:** vì là tiền thật, phần bảo mật không được làm sau. Nó nằm ở Phase 0, không phải Phase cuối.

> Ghi chú phương pháp: không chạy Explore/Plan subagent cho plan này — đây là project Flutter mới hoàn toàn, không liên quan repo `scale-network` (React Native), nên không có codebase để khảo sát. Toàn bộ nội dung đến từ research web + tra cứu pub.dev trực tiếp.

---

## 1. Điều kiện tiên quyết (làm trước khi viết dòng code nào)

1. **Tạo ví riêng cho dev.** Không bao giờ import seed phrase ví cá nhân đang có tiền vào app tự viết. Sinh ví mới, nạp đúng $5–10.
2. **Coi seed phrase dev như đã lộ.** Bạn sẽ debug, print, dump state. Giả định nó sẽ rò rỉ, và chấp nhận mất số tiền đó.
3. **Dev loop chạy Base Sepolia, chỉ chuyển sang Base mainnet khi verify từng flow.** Base Sepolia dùng được cho Send/Receive/History/Get start (5/6 màn). Chỉ Swap bắt buộc mainnet. Không có lý do gì để đốt tiền thật khi debug flow gửi tiền.

---

## 2. Stack thư viện

Các version dưới đây tôi **đã tra pub.dev trực tiếp hôm nay**. Những dòng ghi *(chưa verify)* là package phổ biến tôi chưa kiểm tra version — check lại lúc `flutter pub add`.

### Blockchain core

| Package | Version | Vai trò | Ghi chú |
|---|---|---|---|
| `web3dart` | **3.0.3** (30 ngày trước, 525 likes, 26.6k downloads) | RPC, ký tx, gọi contract ERC-20 | Repo gốc `simolus3/web3dart` đã archive từ 2022; bản hiện tại do publisher `pwa.ir` (xclud) tiếp quản và vẫn release đều. Hợp lệ, nhưng **pin version cứng** trong `pubspec.yaml`, đừng để `^`. |
| `blockchain_utils` | **7.1.0** (13 ngày trước, 12.4k downloads/tuần) | BIP39 mnemonic, BIP32/BIP44 derivation, secp256k1, keccak, EIP-55 | Publisher **unverified** — xem mục Rủi ro chuỗi cung ứng bên dưới. |
| ~~`bip39`~~ | 1.0.6, **5 năm không update** | — | **Không dùng.** Nhiều tutorial cũ vẫn recommend package này. Nó đã chết, dependency `pointycastle` còn ở bản nullsafety pre-release. |

### Bảo mật

| Package | Version | Vai trò |
|---|---|---|
| `flutter_secure_storage` | **10.3.1** (2 tháng trước, 3.26M downloads/tuần) | Lưu seed đã mã hoá vào Keychain (iOS) / Keystore (Android). **Phase 1 dùng cấu hình mặc định — chưa bật biometric-gated entry** |
| `local_auth` | *(chưa verify)* | Cổng Face ID / vân tay trước khi mở khoá key. **Phase 6, chưa cài ở Phase 1** |
| `freerasp` | **8.0.0** (59 ngày trước, 42.8k downloads/tuần, publisher Talsec verified) | Phát hiện root/jailbreak, Frida/Xposed, emulator, debugger. Có free tier |
| `no_screenshot` hoặc `screen_protection` | *(chưa verify)* | FLAG_SECURE + che app switcher. **Lưu ý:** iOS không có API chặn screenshot thật sự, chỉ có notification — đừng coi đây là biện pháp bảo vệ, chỉ là giảm rủi ro vô ý. **Hoãn: chưa cài ở Phase 1, bắt buộc có trước bản release đầu tiên** |

### App framework

| Package | Vai trò |
|---|---|
| `flutter_riverpod` + `riverpod_annotation` *(chưa verify)* | State + cache + auto-refetch. Gần nhất với React Query bạn quen |
| `go_router` *(chưa verify)* | Routing, redirect guard theo trạng thái khoá ví |
| `freezed` + `json_serializable` *(chưa verify)* | Model bất biến, union type cho tx state |
| `dio` *(chưa verify)* | HTTP client gọi Etherscan/0x/CoinGecko |
| `drift` *(chưa verify)* | SQLite cache cho lịch sử giao dịch + sổ địa chỉ. Do simolus3 maintain, rất active |
| **`decimal`** *(chưa verify)* | **Bắt buộc.** Xem mục Số học bên dưới |

### UI

| Package | Màn dùng |
|---|---|
| `mobile_scanner` *(chưa verify)* | Quét QR địa chỉ ở màn Send / Scan |
| `qr_flutter` *(chưa verify)* | Sinh QR ở màn Receive |
| `fl_chart` *(chưa verify)* | Biểu đồ giá trong portfolio |
| `flutter_svg`, `cached_network_image` *(chưa verify)* | Logo token |

### Chưa cần, nhưng biết để sau

`reown_walletkit` **1.4.0** (publisher reown.com verified) — WalletConnect v2, để ví của bạn kết nối vào dApp. Không nằm trong 6 màn hiện tại. Package cũ `walletconnect_flutter_v2` đã bị thay thế bởi package này, đừng dùng bản cũ.

---

## 3. Dịch vụ ngoài

| Nhu cầu | Dịch vụ | Ghi chú |
|---|---|---|
| RPC node | **Alchemy** (free tier 30M compute units/tháng) | Có endpoint Base mainnet + Base Sepolia. Đừng dùng public RPC cho production — rate limit không đoán trước |
| Số dư token | Alchemy `alchemy_getTokenBalances` | Rẻ hơn nhiều so với gọi `balanceOf` từng token |
| Lịch sử giao dịch | **Etherscan API V2** (`chainid=8453`) | V2 gộp 60+ chain vào một API key. Free tier 5 call/giây |
| Giá token | **CoinGecko** free tier | Cache lại, đừng gọi mỗi lần rebuild |
| Swap | **0x Swap API v2** | Base (8453) có trong danh sách hỗ trợ |

**Cảnh báo về API key:** key nhúng trong app mobile là **lấy ra được** — không có cách nào giấu thật sự. Với dự án cá nhân quy mô nhỏ thì chấp nhận được, nhưng phải: (a) bật giới hạn theo bundle ID trên dashboard Alchemy, (b) đặt hạn mức chi tiêu, (c) không commit key vào git, dùng `--dart-define`. Nếu sau này public app, phải dựng proxy backend.

---

## 4. Ba quyết định kỹ thuật quan trọng nhất

### 4.1 Số học — nguồn gốc bug số 1 của app ví

**Không bao giờ dùng `double` cho số dư token.** `double` là IEEE-754, 1 ETH = 10^18 wei vượt xa 53 bit mantissa của nó. Dùng `double` là mất tiền, không phải sai hiển thị.

Quy tắc:
- Lưu trữ & tính toán: `BigInt` (đơn vị wei / smallest unit)
- Hiển thị: chuyển sang `Decimal`, format theo `decimals` của token
- Nhập liệu: parse string → `Decimal` → `BigInt`, không qua `double` ở bất kỳ bước nào
- Mỗi token có `decimals` **riêng** — USDC trên Base là 6, không phải 18. Hardcode 18 là bug kinh điển

Nên bọc thành một value type `TokenAmount { BigInt raw; int decimals; }` với `freezed`, và cấm tuyệt đối `.toDouble()` trong toàn repo.

### 4.2 Quản lý khoá

Luồng đúng:

```
Mnemonic (BIP39, 12 hoặc 24 từ)
  → seed (PBKDF2)
  → derive theo BIP44 path m/44'/60'/0'/0/0
  → private key
  → EthPrivateKey (web3dart) → ký
```

Nguyên tắc lưu trữ:
- **Chỉ lưu mnemonic**, đã mã hoá, trong `flutter_secure_storage`. Không lưu private key riêng — derive lại mỗi lần cần.
- Cổng xác thực: `flutter_secure_storage` v10 hỗ trợ biometric-gated entry.
  **Phase 1 CHƯA bật** — quyết định đã chốt: không passcode tự chế, không tự viết KDF/AES, và tạm thời không biometric. Mở app là dùng được, màn xem recovery phrase không hỏi gì.
  *Rủi ro đã chấp nhận:* bản build Phase 1 **không được cầm quá $5–10**; ai mở được máy là đọc được seed.
  Cổng thật (biometric + auto-lock) làm ở **Phase 6** — chỉ là bọc thêm một lớp gate quanh `readMnemonic()`, **không đổi storage layout** nên không cần migration.
- Private key **chỉ tồn tại trong RAM trong lúc ký**, ghi đè buffer ngay sau đó. Không giữ trong provider state.
- Mnemonic **không được** xuất hiện ở: log, `print`, analytics, crash reporter, clipboard không giới hạn thời gian, hoặc bất kỳ widget nào không có FLAG_SECURE.
- Android: bắt buộc `android:allowBackup="false"` trong `AndroidManifest.xml`. `flutter_secure_storage` v10 đổi sang RSA-OAEP + AES-GCM và sẽ ném `InvalidKeyException` nếu auto-backup khôi phục dữ liệu cũ trên máy khác.
- Màn hiển thị recovery phrase: che sẵn, buộc user chạm để hiện, bật chống screenshot, và có bước xác nhận lại thứ tự từ.

### 4.3 0x Swap API v2 — chọn đúng endpoint

0x v2 có hai flavor:

- `/swap/permit2/quote` — dùng Permit2, cần ký **EIP-712 typed data**. web3dart không có sẵn EIP-712 signing → phải tự implement encode struct. Tốn thời gian và dễ sai.
- `/swap/allowance-holder/quote` — dùng ERC-20 `approve` thông thường. **Chọn cái này.**

*(Cần verify lại tên endpoint chính xác trong docs khi bắt tay làm — tôi lấy từ tài liệu 0x v2 nhưng chưa đọc trực tiếp trang endpoint.)*

Luồng swap:
1. `GET /price` — quote không ràng buộc, để hiển thị realtime khi user gõ
2. `GET /quote` — chỉ gọi khi user sắp confirm, trả về calldata thật
3. Kiểm tra allowance; nếu thiếu → gửi tx `approve` trước, **approve đúng số cần, không approve unlimited**
4. Ký và gửi tx swap bằng calldata từ 0x
5. Poll receipt

---

### 4.4 Danh tính ví & account — quyết định ràng buộc mọi phase sau

**Phase 1 làm đúng 1 ví, 1 account.** UI không có switcher, derivation luôn `accountIndex = 0`, chỉ một address.

Nhưng data model **phải chừa sẵn chỗ cho nhiều ví / nhiều account ngay từ đầu** — chi phí lúc này gần bằng 0, còn sửa sau khi user đã giữ tiền thì phải viết migration chạy một lần trên máy thật:

- Model là **danh sách**: `List<WalletMeta>` với `WalletMeta { id, name, source, accountIndex, address, isBackedUp }`. Phase 1 list luôn có đúng 1 phần tử.
- Secure storage key **có tham số**: `wallet_mnemonic_$walletId`. **Cấm** hằng số `"mnemonic"`.
- `currentAccountProvider` là **nguồn duy nhất** để mọi feature lấy address. Không hardcode, không truyền address qua constructor rồi giữ lại.
- `switchAccount(accountId)` viết ngay ở Phase 1 (chỉ set id + persist) dù chưa có UI gọi — để ràng buộc kiến trúc và test được.

**Derivation path — quy ước MetaMask:** account thứ n là `m/44'/60'/0'/0/n` (tăng `addressIndex`), **không** phải kiểu Ledger Live `m/44'/60'/n'/0/0`. Chọn sai quy ước thì address không khớp MetaMask và tiền nằm ở địa chỉ không mở được.

**Ràng buộc "key theo address" — áp dụng từ Phase 2 trở đi.** Switch account chỉ được phép là "đổi `currentAccountId`", mọi logic phía sau giữ nguyên. Muốn vậy thì không được cache theo kiểu global:

| Hạng mục | Bắt buộc | Sai lầm cần tránh |
|---|---|---|
| Provider dẫn xuất (balance, history, portfolio) | `FutureProvider.family<T, String address>` | `FutureProvider<T>` singleton → đổi account là lẫn dữ liệu |
| Bảng drift history | primary key `(address, txHash)` | chỉ `txHash` → thấy lịch sử của account trước |
| Bảng drift / cache số dư | key `(address, tokenAddress)` | — |
| Widget / notifier | `ref.watch(currentAccountProvider)` để rebuild | Nhận address qua constructor rồi giữ trong state → không rebuild khi switch |

Phase 1 vẫn viết đúng dạng trên nhưng chỉ gọi với một address duy nhất.

**Ngoại lệ:** *tổng portfolio nhiều account* là **logic mới**, không phải hệ quả của switch account — nếu sau này Home muốn hiện tổng của tất cả account thì phải fetch song song n address kèm rate-limit. Mặc định: Home chỉ hiện account đang chọn.

---

### 4.5 Theme — bắt buộc với mọi tính năng mới

Bộ token đã dựng ở `lib/app/theme/` (Phase 0). **Mọi màn hình, widget, tính năng mới phải dùng lại nó:**

| Loại | Cách gọi | Cấm |
|---|---|---|
| Màu | `context.colors.*` | `Color(0xFF...)`, `Colors.*` trong `lib/features/` |
| Chữ | `context.typo.*` | Dựng `TextStyle` tay cho số tiền — mất tabular figures, số sẽ nhảy ngang khi refresh |
| Khoảng cách, bo góc | `AppDimens.*` | Số magic |
| Địa chỉ ví, tx hash | `AppFormat.shortAddress()` + `context.typo.address` | Tự cắt chuỗi, dùng font sans |

**Nếu thiết kế cần màu hoặc font ngoài bộ hiện có: dừng lại và hỏi ý kiến trước khi làm.** Không tự thêm token, không hardcode kiểu "tạm rồi sửa sau". Token mới chỉ được thêm vào `AppColors` / `AppTypography` sau khi đã thống nhất — như vậy light theme sau này chỉ cần đăng ký thêm một instance, không phải refactor màn hình.

Token màu đặt tên theo **vai trò** (`danger`, `warning`, `success`), không theo giá trị. `qrSurface` cố ý màu trắng và không theo dark scheme — QR cần nền sáng để quét được.

Kiểm tra bằng mắt: `DesignGallery` (`lib/app/theme/design_gallery.dart`) render toàn bộ token.

---

### 4.6 Confirm & thông báo — sheet, không phải dialog

**Mọi xác nhận, cảnh báo, thông báo kết quả trong app đều là bottom sheet trượt lên.** Không có ngoại lệ nào cho "chỉ hỏi một câu ngắn".

| Nhu cầu | Dùng | Ở |
|---|---|---|
| Hỏi xác nhận 2 nút (xoá ví, gửi tiền, bỏ qua backup) | `showAppConfirmSheet(...) → Future<bool>` | `lib/shared/widgets/app_action_sheet.dart` |
| Thông báo / kết quả, 1–2 nút, cần giá trị trả về khác `bool` | `showAppActionSheet<T>(...)` | cùng file |
| Sheet có nội dung riêng (danh sách, form) | `showAppSheet` + `AppSheet` shell | `lib/shared/widgets/app_sheet.dart` |

**Cấm trong `lib/features/`:** `AlertDialog`, `CupertinoAlertDialog`, `SnackBar`, `showDialog`, và gọi thẳng `showModalBottomSheet` (bỏ qua `showAppSheet` là lệch bo góc + cấu hình safe area).

Cấu trúc bắt buộc của sheet thông báo: **icon tròn theo vai trò → title → message → 1–2 nút full-width xếp dọc**. Tone (`AppSheetTone.success/warning/danger/neutral`) chỉ đổi màu icon; nút huỷ luôn là `SecondaryButton` nằm dưới. Với tone `danger`, nút chính là `DangerButton`.

**Quy ước giá trị trả về:** dismiss (kéo xuống / chạm ra ngoài) **không bao giờ** được tính là đồng ý. `showAppConfirmSheet` trả `false` khi dismiss. Nếu màn hình cần phân biệt "dismiss" với "chọn nút phụ" — như màn Recovery phrase, nơi dismiss phải ở lại chứ không được skip — thì dùng `showAppActionSheet<bool>` và xử lý `null` riêng.

---

## 5. Cấu trúc thư mục đề xuất

```
lib/
  main.dart
  app/            router.dart, l10n/
    theme/        app_colors.dart, app_typography.dart, app_dimens.dart,
                  app_theme.dart, theme_context.dart, design_gallery.dart
  core/
    crypto/       mnemonic.dart, key_derivation.dart, signer.dart
    money/        token_amount.dart, formatters.dart
    security/     secure_store.dart, biometric_gate.dart, rasp.dart
    network/      dio_client.dart, rpc_client.dart
  data/
    chain/        base_chain.dart (chainId, RPC, explorer)
    repositories/ balance_repo.dart, history_repo.dart, swap_repo.dart,
                  price_repo.dart, contacts_repo.dart
    db/           drift schema
  features/
    onboarding/   create_wallet, backup_phrase, verify_phrase, import_wallet
    wallet/       main_shell (bottom nav 4 tab), portfolio (home), token_detail
    send/         amount, recipient, contacts, review, result
    receive/      qr, share
    swap/         quote, select_token, slippage, review, result
    history/      list, detail
    settings/     security, currency, language, about
    borrow/       placeholder tab (chưa có nội dung)
    lending/      placeholder tab (chưa có nội dung)
    statistics/   placeholder tab (chưa có nội dung)
  shared/         widgets/, extensions/
```

Mỗi feature một folder, export qua barrel — giống pattern `src/features/` bạn đang dùng ở repo RN, nên chuyển đổi tư duy sẽ nhẹ.

---

## 6. Lộ trình triển khai

### Phase 0 — Nền tảng & bảo mật (làm trước, không skip)
- Scaffold project, Riverpod + go_router + freezed
- `SecureStore` wrapper quanh `flutter_secure_storage`
- `freerasp` cảnh báo root/jailbreak
- Build release có `--obfuscate --split-debug-info`

**Đã chốt hoãn — chưa cài thư viện, nhưng KHÔNG được quên (mỗi cái có hạn chót cứng):**

| Hạng mục | Hạn chót |
|---|---|
| `TokenAmount` + package `decimal` + test biên (0, 1 wei, max uint256, token 6 decimals) | **Trước Phase 2** — không được để tới lúc hiển thị số dư mới làm |
| `local_auth` + biometric gate | Phase 6 |
| `no_screenshot` cho các màn nhạy cảm | **Trước bản release đầu tiên.** Đã quan sát thực tế trên emulator: chưa có FLAG_SECURE nên toàn bộ 12 từ **hiện nguyên vẹn trong app switcher** của Android khi rời màn recovery phrase |
| `AndroidManifest`: `allowBackup=false` | **Trước bản release đầu tiên / trước khi nạp tiền thật** |

### Phase 1 — Get start (onboarding)
Màn từ Figma: Get start → Create Username → Profile is ready → push notifications → Protect your wallet → Wallet

- Sinh mnemonic, hiển thị backup, verify lại thứ tự từ. **Quyết định đã đổi (2026-08-01): backup + verify được phép skip** — màn Recovery phrase có nút "Back up later" kèm dialog cảnh báo, user vào app trải nghiệm trước rồi backup sau. Skip **không** set `isBackedUp`; cờ đó ở lại `false` và là thứ Settings dùng để nhắc.
  *Hệ quả bắt buộc:* Phase 6 phải có (a) nhắc backup thường trực khi `isBackedUp == false`, (b) màn Recovery phrase trong Settings. Cho tới lúc đó, một ví created chưa ghi seed vẫn mở app được — thêm một lý do bản build này không được cầm quá $5–10.
- Import mnemonic có sẵn; validate **checksum BIP39 ngay tại UI**, chỉ enable nút khi checksum pass
- Import bằng **private key nằm ngoài phạm vi** — chỉ lưu mnemonic (xem 4.2)
- Không có passcode, không có biometric ở phase này (xem 4.2)
- Derive địa chỉ, lưu mã hoá — 1 ví / 1 account, model chừa chỗ multi (xem 4.4)
- **Checkpoint bắt buộc:** xem mục Verification

### Phase 2 — Receive + Portfolio
- Hiển thị địa chỉ, QR, copy có timeout xoá clipboard
- Số dư native + ERC-20 qua Alchemy
- Giá qua CoinGecko, tổng portfolio
- **Mọi provider/cache key theo address ngay từ đầu** (xem 4.4) — không dùng provider singleton

### Phase 3 — History
- Etherscan V2 `txlist` + `tokentx`, gộp và sort
- Cache vào drift, pagination — **primary key `(address, txHash)`**, không phải `txHash` (xem 4.4)
- Màn chi tiết: hash, gas đã trả, link ra Basescan

### Phase 4 — Send
- Validate địa chỉ + **checksum EIP-55**, cảnh báo địa chỉ toàn thường
- Quét QR, sổ địa chỉ (Contacts, Add/Edit/Delete từ Figma)
- Ước lượng gas EIP-1559 (`maxFeePerGas` / `maxPriorityFeePerGas`), cộng buffer
- **`eth_call` simulate trước khi gửi** — bắt revert trước khi mất gas
- Màn Confirm nhiều bước đúng như Figma, hiển thị rõ: nhận, số lượng, phí, tổng
- Theo dõi pending → confirmed

### Phase 5 — Swap
- Select token, nhập số lượng, `/price` realtime có debounce
- Hiển thị route, price impact, slippage (mặc định 0.5%, cho chỉnh)
- Approve nếu cần → swap → poll receipt
- **Cảnh báo price impact cao**, chặn nếu > ngưỡng

### Phase 6 — Settings + hardening
- Backup / Recovery phrase (gated bằng biometric)
- Bật/tắt Face ID, đổi currency hiển thị, ngôn ngữ
- Auto-lock sau N phút nền
- Xoá ví (yêu cầu gõ xác nhận)

---

## 7. Verification

### Checkpoint sống còn — cuối Phase 1, trước khi nạp bất kỳ đồng nào

1. **Test vector BIP39.** Lấy vector chính thức từ [BIP-39 spec](https://github.com/bitcoin/bips/blob/master/bip-0039/bip-0039-wordlists.md) / repo `trezor/python-mnemonic`, assert mnemonic → seed → private key khớp từng byte. Đây là unit test, không phải test tay.
2. **Đối chiếu chéo với MetaMask.** Sinh mnemonic mới trong app bạn → import cùng mnemonic đó vào MetaMask → **hai địa chỉ phải giống hệt nhau**. Nếu lệch, derivation path hoặc encoding sai, và mọi đồng bạn gửi vào sẽ nằm ở địa chỉ bạn không có key.
3. Lặp lại bước 2 với mnemonic 12 từ và 24 từ.

Chỉ khi cả 3 pass mới được nạp tiền.

### Từng phase
- Phase 2–4: chạy **Base Sepolia** trước, lấy ETH từ faucet, gửi qua lại giữa app và MetaMask
- Phase 4 lên mainnet: giao dịch đầu tiên gửi **$0.10** cho chính địa chỉ MetaMask của bạn, verify trên Basescan, rồi mới tăng
- Phase 5: swap thử **$1**, so số nhận được với quote hiển thị
- Trước khi coi là xong: `flutter build apk --release --obfuscate --split-debug-info=build/symbols` và test lại trên bản release (secure storage hành xử khác giữa debug và release)

---

## 8. Cạm bẫy đã biết

| Cạm bẫy | Hậu quả |
|---|---|
| Dùng `double` cho số dư | Mất tiền, sai âm thầm |
| Hardcode 18 decimals | USDC (6 decimals) sai 10^12 lần |
| Approve unlimited | Contract độc rút sạch token |
| Không simulate trước khi gửi | Tx revert, mất gas |
| Bỏ qua checksum EIP-55 | Gửi vào địa chỉ gõ sai → mất vĩnh viễn |
| Copy nonce sai khi có tx pending | Tx bị thay thế hoặc kẹt |
| Log seed lúc debug rồi quên xoá | Lộ ví |
| Slippage mặc định quá cao | Bị sandwich attack |
| Tin `blockchain_utils` không pin version | Publisher unverified — một release độc là mất ví. **Pin cứng, đọc changelog trước mỗi lần bump** |
| Hardcode màu / `TextStyle` rời rạc thay vì dùng token | Mỗi màn một sắc thái khác nhau, số dư nhảy ngang vì mất tabular figures, và không thêm được light theme mà không refactor toàn bộ |
| Dùng `AlertDialog` / `SnackBar` thay vì sheet (xem 4.6) | Nút xác nhận co lại thành chữ nhỏ cạnh nút huỷ — ở màn xoá ví và gửi tiền đó là chạm nhầm mất tiền, không phải lỗi thẩm mỹ |
| Hardcode storage key `"mnemonic"` thay vì `wallet_mnemonic_$id` | Phải viết migration chạy một lần trên máy user đang giữ tiền — fail là mất seed |
| Provider / cache singleton thay vì key theo address | Switch account xong vẫn hiện số dư & lịch sử của account cũ |
| Nhầm `m/44'/60'/n'/0/0` với `m/44'/60'/0'/0/n` khi thêm account | Address không khớp MetaMask, tiền nằm ở địa chỉ không mở được |
| Giữ mnemonic / private key trong provider state (kể cả tạm) | Rò rỉ qua devtools, hot reload, crash dump |

---

## 9. Rủi ro chuỗi cung ứng — điểm cần bạn quyết

Hai package nằm trên đường đi của private key:

- `web3dart` — publisher `pwa.ir` verified, nhưng là bên tiếp quản từ repo đã archive
- `blockchain_utils` — publisher **unverified**, 12.4k downloads/tuần

Với $5–10 thì rủi ro chấp nhận được. Nhưng nguyên tắc: **pin version tuyệt đối** (`web3dart: 3.0.3`, không phải `^3.0.3`), commit `pubspec.lock`, và đọc diff changelog trước khi nâng. Nếu sau này app giữ số tiền đáng kể, phải tự audit hoặc vendor phần derivation vào repo.

---

## 10. Nguồn

- [0x Supported Chains](https://docs.0x.org/docs/introduction/supported-chains)
- [LI.FI — Testing your integration](https://docs.li.fi/li.fi-api/li.fi-api/requesting-a-quote/testing-your-integration)
- [pub.dev/web3dart](https://pub.dev/packages/web3dart) · [blockchain_utils](https://pub.dev/packages/blockchain_utils) · [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) · [freerasp](https://pub.dev/packages/freerasp) · [reown_walletkit](https://pub.dev/packages/reown_walletkit)
- [Etherscan API V2](https://docs.etherscan.io/introduction)
- [MetaMask — chain-agnostic web3 wallet in Flutter](https://docs.metamask.io/tutorials/flutter-wallet/)
- [Flutter Gems — Web3/Crypto/Blockchain packages](https://fluttergems.dev/web3-crypto-blockchain/)
