# ImmersionKit

ImmersionKit is a lightweight, on-device SDK for **VALUE MEASUREMENT** -- computing “Value” and “Psychological Safety” indices from raw datapoints, storing time-series locally, and querying/deriving **Key Moments**. It’s built for privacy-first apps: data is processed and stored **on device**.  No personal information or health data is saved, stored, or transmitted by this SDK.

Visit [Immersion Neuroscience](https://getimmersion.com) for more details.

## Table of contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Getting started](#getting-started)
- [Public APIs](#public-apis)
  - [Activation](#activation)
  - [Scoring (single point)](#scoring-single-point)
  - [Scoring (batch)](#scoring-batch)
  - [Query (time series)](#query-time-series)
  - [Key Moments](#key-moments)
- [Identity scopes](#identity-scopes)
- [Logging](#logging)
- [Error handling](#error-handling)
- [Data model & recommendations](#data-model--recommendations)
- [Troubleshooting](#troubleshooting)
- [License](#license)

---

## Features

- ⚡️ **On-device scoring**: compute Value & Safety indices from raw inputs.
- 🗃️ **Local time-series store** (Pro): SwiftData buckets at 1s, 1m, 5m, 15m, 1h, 1d.
- 🔎 **Query by aggregation** (Pro): return per-bucket series with count-weighted merges.
- ⭐ **Key Moments** (Pro): detect sustained high/low engagement segments per identity.
- 🔐 **Privacy-first**: data stays on device; no PII or health data is save, stored, or sent.
- 🧭 **Friendly API**: Safe async calls, clear errors and logging, identity scoping.

## Requirements

- **Swift**: Swift 5.9+
- **Apple OS** (SwiftData minimums):
  - iOS 17+ / iPadOS 17+
  - watchOS 10+
  - tvOS 17+ / visionOS 1.0+
  - macOS 14+ (for Mac apps)
- **Build**: Xcode 15+
- **Networking**: Your app must reach your validation endpoint for `activate(…)` (SDK gracefully falls back to cached entitlements if offline).

> ℹ️ No special Info.plist keys are required for baseline use. If you add your own background ingestion or health data collection, add the appropriate capabilities/entitlements per Apple guidelines.

## Installation

### Swift Package Manager

1. In Xcode: **File → Add Packages…**
2. Enter your repository URL, then **Add Package**.
3. Link **ImmersionKit** to your app target.

```swift
import ImmersionKit
```

## Getting started

1. **Activate** the SDK at app launch (e.g., `AppDelegate`).
2. **Score** datapoints as they arrive.
3. (Pro) **Query** time-series for charts/analytics.
4. (Pro) **Calculate/Read Key Moments** for daily summaries.

> ⏱️ **Timestamps must be UTC**. Convert local captures to UTC before calling the SDK.

---

## Public APIs

### Activation

Call once at startup:

```swift
let ok = try await Immersion.activate(company: "your_company_id",
                                      key: "your_secret_key")
if ok {
    // proceed; Pro features enabled when your plan allows
}
```

- Returns `true` on success. If offline, the SDK falls back to **cached entitlements** (stored in Keychain) and still returns `true` if a valid cache exists.
- Check `Immersion.activated` to see whether the SDK is active at any time.

```swift
if Immersion.activated {
    // safe to call scoring, queries, etc.
}
```

---

### Scoring (single point)

```swift
import ImmersionKit

let point = ImmersionDataPoint(
    heartRate: 78,
    date: Date() /* ensure this is UTC! */
)

// Default identity is "me". Writes require a single identity.
let score = try await Immersion.score(point: point,
                                      scope: .identity("me"),
                                      sensor: .unknown)
// score.valueIndex, score.safetyIndex, score.date
```

- On Pro, the second-by-second score is **ingested into the local time-series** (1s bucket) and rolled up automatically.

Completion-handler variant also exists.

---

### Scoring (batch)

```swift
let points: [ImmersionDataPoint] = /* build UTC series */

let result = try await Immersion.scores(points: points,
                                        scope: .identity("me"),
                                        sensor: .unknown,
                                        interpolate: true)
// result.valueIndex (mean), result.safetyIndex (mean), result.scores (per second)
```

- `interpolate: true` fills small gaps (<10s) at 1 Hz.
- On Pro, the per-sample results are also **persisted** to the local store.

Completion-handler variant also exists.

---

### Query (time series)

> **Pro only.** Queries are **on-device** and return a bucketed series plus simple averages.

```swift
let from = Date(timeIntervalSinceNow: -3600) // last hour
let to   = Date()

let (vMean, sMean, series) = try await Immersion.query(.oneMinute,
                                                       from: from,
                                                       to: to,
                                                       scope: .identity("me"))
```

- Aggregations: `.oneSecond`, `.oneMinute`, `.fiveMinute`, `.fifteenMinute`, `.oneHour`, `.oneDay`
- **Identity scopes**:
  - Lite: `.identity("me")`
  - Pro: `.identity(any)`, `.all`, `.identities(Set<String>)`
- When merging multiple identities (`.all` / `.identities`), bucket values are **count-weighted means**.

Completion-handler variant also exists.

---

### Key Moments

> **Pro only.** Per-identity detection for a given **local day** (device timezone).

**Calculate + persist** moments (idempotent unless `forceRecalc`):

```swift
let created = try await Immersion.calculateKeyMoments(for: Date(),
                                                      scope: .identity("me"),
                                                      forceRecalc: false)
// returns only newly created ImmersionKeyMoment items
```

**Read** stored moments for a day:

```swift
let todays = try await Immersion.keyMoments(for: Date(),
                                            scope: .identity("me"))
// [ImmersionKeyMoment]
```

---

## Identity scopes

```swift
public enum IdentityScope: Sendable, Equatable {
  case identity(String)        // one identity (default: "me")
  case all                     // merge all identities (Pro)
  case identities(Set<String>) // merge a subset (Pro)
}
```

- **Writes** (scoring, moments) must specify **one identity**. On Lite, this must be `"me"`.
- **Reads/queries**:
  - Lite: `.identity("me")`
  - Pro: `.identity(any)`, `.all`, `.identities(Set)`

---

## Logging

Tune SDK logging and mirror to the Xcode console:

```swift
Immersion.logLevel(.info)        // .debug, .info, .error, .none
Immersion.setConsoleMirroring(true)
```

Log levels:
- `.debug` – very chatty; useful during integration.
- `.info` – key lifecycle and outcomes (default).
- `.error` – only errors.
- `.none` – silence.

---

## Error handling

Public APIs may throw `ImmersionError`:

```swift
public enum ImmersionError: Error, Sendable {
    case notActivated  // call activate(...) first (or activation failed with no valid cache)
    case notEnabled    // plan/scope doesn’t allow this feature
}
```

- Activation returns `Bool` and **does not** throw `notActivated` on failure; it returns `false` instead and may fall back to cached entitlements if available.
- Other thrown errors can be networking/decoding issues (during activation) or SwiftData availability issues (rare).

---

## Data model & recommendations

- **UTC timestamps**: `ImmersionDataPoint.date` must be **UTC**. Convert local time to UTC before scoring.
- **Sampling**: Scoring expects realistic second-level cadence; use `interpolate: true` for small gaps.
- **On-device storage** (Pro):
  - Buckets: `1s`, `1m`, `5m`, `15m`, `1h`, `1d`
  - Query windows are **[from, to)** and return `ImmersionScore` per bucket start.
- **Key Moments**: Per-identity detection; device timezone is used to infer the local day boundaries.

---

## Troubleshooting

- **`notActivated`**: Ensure `Immersion.activate(company:key:)` is called on launch and that the device can reach your validation endpoint; otherwise a valid cached entitlement must exist to proceed.
- **`notEnabled`**: You’re using a Pro-only API or identity scope without Pro entitlements.
- **No data in queries**: Make sure you’re scoring data first (Pro), that SwiftData is available on the target OS, and your query’s `[from, to)` aligns with the ingested timestamps.
- **Weird merges with `.all`**: Ensure your app supplies consistent UTC timestamps. The SDK normalizes to the aggregation boundary, but non-UTC input will still look wrong.

---

## License

See [Terms & Conditions](https://your6.com) on Your6.com

Visit [Immersion Neuroscience](https://getimmersion.com) for more details.

---

### Appendix: Types quick reference

```swift
public struct ImmersionDataPoint: Sendable, Hashable {
    public let heartRate: Int     // BPM
    public let date: Date         // UTC
}

public struct ImmersionScore: Sendable, Hashable {
    public let date: Date         // UTC
    public let valueScore: Double // 0.0–100.0
    public let safetyScore: Double
    public var valueIndex: Int    // 0–100 (derived)
    public var safetyIndex: Int
}

public struct ImmersionKeyMoment: Sendable {
    public let identity: String
    public let start: Date        // UTC
    public let end: Date          // UTC
    public let durationMin: Int
    public let kind: String       // "KM" | "LM"
    public let peakValueIdxMin: Double
    public let avgValueIdxMin: Double
    public let safetyAvg: Double
    public let safetyCoveragePct: Double // 0.0–1.0
    public let safetyStatus: String      // "ok" | "partial" | "none"
}

public enum ImmersionAggregation: String, Sendable, Hashable {
    case oneSecond = "1s", oneMinute = "1m", fiveMinute = "5m",
         fifteenMinute = "15m", oneHour = "1h", oneDay = "1d"
}

public enum IdentityScope: Sendable, Equatable {
    case identity(String)        // default "me"
    case all
    case identities(Set<String>)
}
```

&copy; Immersion Neuroscience Inc. All rights reserved. By downloading or installing this SDK you are agreeing to the terms and conditions of use outlined at [Your6.com](https://your6.com) and [GetImmersion.com](https://getimmersion.com)
