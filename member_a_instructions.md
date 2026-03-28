# Member A — Frontend / UI
### ApexVerify | Google Solution Challenge 2026

---

## Your Role

You own the Flutter desktop dashboard — the Stream Monitor screen. You are both the first person to start (you create the shared project) and the last person to finish (you wire everything together in Phase 3). Your work splits into two clear parts with a hard boundary between them.

---

## Tech Stack

| Package / Tool | Purpose |
|---|---|
| `Flutter Desktop (Windows)` | The app itself |
| `StreamBuilder` | Reactive UI updates from live streams |
| `flutter_riverpod` | State management across widgets |
| `MockFrameSampler` (from Member B) | Stand-in frame stream during Part 1 |
| `FrameSampler` (from Member B) | Real frame stream in Part 2 |
| `Stream<ViolationAlert?>` (from Member D) | Alert stream wired in Part 2 |

---

## Before You Start — Day 1 Responsibilities

You are the one who creates the shared project. Do this first, before any other member starts.

```bash
flutter create apexverify
cd apexverify
flutter config --enable-windows-desktop
flutter run -d windows
```

Confirm a blank window opens. Then push to a shared GitHub/GitLab repo and send the URL to all three members.

Also on Day 1 — before splitting off into your own work:

- Agree with the team on the `MatchSnapshot` model class fields. Member C writes to it, Member D reads from it. The fields are: `homeTeam`, `awayTeam`, `score`, `clock`, `hasOverlay`. Commit this as a shared Dart file.
- Ask Member B for `MockFrameSampler` immediately. It takes them 10 minutes to write and you are blocked on the frame preview panel without it.
- Ask Member D to share the `ViolationAlert` model class as soon as they have the fields defined — you need the field names to build the alert card UI, even before the logic works.

---

## Part 1 — Build the UI Shell (Phase 2, Days 2–4)

> **You work completely alone in Part 1. No dependency on Members C or D.**
> The only thing you need from outside is `MockFrameSampler` from Member B — get it on Day 1.

### What to build

**1. `StreamMonitorScreen` — the main screen**

The root widget of the app. Contains a URL input field and a "Start Monitoring" button. On submit, it passes the URL to `FrameSampler` (or `MockFrameSampler` during Part 1) and initialises the two `StreamBuilder` widgets below.

**2. Frame preview panel**

A widget that subscribes to `MockFrameSampler.startSampling(url)` and renders each emitted `Uint8List` as an `Image.memory` widget. Updates every 5 seconds as new frames arrive.

```dart
StreamBuilder<Uint8List>(
  stream: mockFrameSampler.startSampling(url),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return const CircularProgressIndicator();
    return Image.memory(snapshot.data!);
  },
)
```

**3. Status indicator widget**

A simple coloured circle — green when no alert is active, red when a `ViolationAlert` is present. In Part 1, hardcode it to green. It gets wired to the real stream in Part 2.

**4. Alert card widget**

Build the full card UI now, even though it will be empty during Part 1. It should display:
- A severity badge (e.g. "HIGH RISK")
- A description text field (will show Gemini's output in Part 2)
- A timestamp field
- A "mismatch" field showing which value was wrong (e.g. "score")

Use the `ViolationAlert` field names from Member D to build against. If Member D hasn't shared the model yet, use placeholder strings — swap them for real fields the moment you receive it.

**5. DMCA log panel**

A scrollable `ListView` that displays a list of past `ViolationAlert` entries from the current session. In Part 1, this can be an empty list with a "No violations detected" placeholder text.

**6. Screenshot save button**

A button that calls `frameSampler.saveCurrentFrame()` to write the current frame to disk as a PNG. Wire this to `MockFrameSampler` in Part 1 — it can be a no-op stub that just prints to console.

### How to test Part 1

By the end of Phase 2, your UI should:
- Show a live-updating frame preview using `MockFrameSampler` (a static test image refreshing every 5 seconds)
- Display the status indicator (green, hardcoded)
- Show the alert card UI (empty, no data yet)
- Show the DMCA log (empty list)
- Have a working screenshot button (no-op or stub)

> **Part 1 ends at the close of Phase 2 (Day 4).** The UI shell is complete and tested. You now wait for Phase 3 Step 3.3 — the moment Member D's alert stream is ready to hand off.

---

## Coordination Points During Part 1

| Who | What you need | When | Action if delayed |
|---|---|---|---|
| Member B | `MockFrameSampler` | Day 1 | Hardcode a static `Image.asset` in the frame panel and swap it in later |
| Member D | `ViolationAlert` model fields | Phase 2, as early as possible | Use placeholder strings and rename fields when model arrives |
| Team | `MatchSnapshot` agreed fields | Day 1 | Needed for understanding — you don't use it directly but Member C and D do |

---

## Part 2 — Wire Real Data (Phase 3, Step 3.3)

> **Part 2 begins when Member D's `Stream<ViolationAlert?>` is confirmed working (Phase 3 Step 3.3).**
> This is after Steps 3.1 (B+C) and 3.2 (C+D) are verified. Do not start Part 2 until those pass.

### What changes

**1. Swap `MockFrameSampler` for real `FrameSampler`**

This is a one-line change in your provider or constructor. The `Stream<Uint8List>` interface is identical — nothing else in your code changes.

```dart
// Part 1
final sampler = MockFrameSampler();

// Part 2 — one line change
final sampler = FrameSampler();
```

**2. Wire `StreamBuilder` to Member D's alert stream**

Replace the hardcoded green status indicator with a live `StreamBuilder` on `Stream<ViolationAlert?>`:

```dart
StreamBuilder<ViolationAlert?>(
  stream: comparisonService.alertStream,
  builder: (context, snapshot) {
    final alert = snapshot.data;
    return StatusIndicator(isViolation: alert != null);
  },
)
```

**3. Populate the alert card**

When a non-null `ViolationAlert` arrives, populate the card with:
- `alert.severity` → severity badge
- `alert.description` → Gemini's text description of the violation
- `alert.timestamp` → formatted timestamp
- `alert.fieldMismatch` → which field was wrong

**4. Make the DMCA log append entries**

Each time a non-null alert arrives, append it to a local `List<ViolationAlert>` in your state and rebuild the `ListView`.

**5. Confirm the screenshot save button works end-to-end**

With the real `FrameSampler` in place, confirm that clicking the button actually writes a PNG to disk with a timestamped filename.

### How to test Part 2

Ask Member D to deliberately corrupt a Firestore value. Then verify:
- Status indicator turns red within 10 seconds
- Alert card shows a real Gemini description (not placeholder text)
- DMCA log appends the new entry
- Restoring the correct Firestore value makes the next frame return green

> **Part 2 is complete when all four of the above behaviours are confirmed.**

---

## Full Timeline Summary

| Phase | Days | What you do | Depends on |
|---|---|---|---|
| Phase 1 | Day 1 | Create project, push repo, agree MatchSnapshot model, get MockFrameSampler | Member B (MockFrameSampler) |
| Phase 2 — Part 1 | Days 2–4 | Build full UI shell against MockFrameSampler | Nothing (solo) |
| Phase 3 Step 3.1 | Day 5 | Watch B+C connect — no action required from you | — |
| Phase 3 Step 3.2 | Day 5 | Watch C+D connect — no action required from you | — |
| Phase 3 Step 3.3 — Part 2 | Day 5–6 | Swap mock for real streams, wire alert card and log | Member B (real stream) + Member D (alert stream) |
| Phase 3 Step 3.4 | Day 6 | Full end-to-end test with all 4 members | Everyone |

---

*ApexVerify — Google Solution Challenge 2026*
