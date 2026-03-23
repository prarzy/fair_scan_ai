# OCR Parser Debugging Summary

## Final Status

Part 1 parser debugging is complete.

- Static image validation: 4/4 images parsed correctly
- OCR parser unit tests: passing (8 tests)
- Analyzer status: clean in project code

Validated static images:
- `assets/test_scoreboards/epl_01.png`
- `assets/test_scoreboards/epl_02.png`
- `assets/test_scoreboards/nba_01.png`
- `assets/test_scoreboards/ucl_01.png`

---

## Issues Identified And Resolved

### Issue 1: epl_01.png
**Raw OCR Text:**
```
MCI
HESTER
0
89:10
0 TOT
HE WORLD'S GAME
FC24
MANCHE
THE WORLD'S
```

**Problem:**
- Initial parser failure included clock/score collision and noisy team extraction.
- Expected: `score: 0-0, clock: 89:10, homeTeam: MCI, awayTeam: TOT`

**Root Cause:**
- Noisy OCR layout `TEAM noise SCORE CLOCK SCORE TEAM` (e.g. `MCI HESTER 0 89:10 0 TOT`) was not handled.
- Score fallback sometimes preferred time-like pairs.
- Team extraction near noisy words could capture non-team tokens.

**Fix Applied:**
- Changed score regex to only accept `-`: `r'\b(\d{1,3})\s*-\s*(\d{1,3})\b'`
- `:` patterns are now reserved for clocks only
- Added compact pattern support for `TEAM noise SCORE CLOCK SCORE TEAM`
- Added isolated-number fallback for score to avoid time-like candidates
- Added team-code fallback when contextual extraction is incomplete/noisy

**Current Result:**
- `homeTeam: MCI, awayTeam: TOT, score: 0 - 0, clock: 89:10`

---

### Issue 2: nba_01.png
**Raw OCR Text:**
```
ESPM
GS
64 CLE 85 3RD 49.8 10
BONUS
BONUS
```

**Problem:**
- Initial parser failure selected wrong numeric pair and missed decimal clock.
- Expected: `score: 64-85, clock: 49.8, homeTeam: GS, awayTeam: CLE`

**Root Cause:**
- Decimal clock format `49.8` (basketball quarter time) not recognized by clock regex
- Space-separated regex picked up `8 10` from nearby text instead of `64 85`

**Fix Applied:**
- Added decimal clock support to regex: `\b\d{1,2}\.\d{1,2}\b(?!\d)`
- Implemented TEAM SCORE TEAM SCORE pattern matching for layouts like "GS 64 CLE 85"
- Better prioritization: dash > space-separated with filtering > TEAM SCORE TEAM SCORE > fallback

**Current Result:**
- `homeTeam: GS, awayTeam: CLE, score: 64 - 85, clock: 49.8`

---

### Issue 3: ucl_01.png
**Raw OCR Text:**
```
90:00
9:34 +9
RMA 2 1 BAY (4-3)
```

**Problem:**
- Initial parser failure selected `9 34` (from `9:34`) as score.
- Expected: `score: 2-1, clock: 90:00, homeTeam: RMA, awayTeam: BAY`

**Root Cause:**
- Multiple space-separated number pairs: "9 34" (from "9:34") and "2 1" (actual score)
- Parser greedily picked first space-separated match "9 34" thinking it was score
- `9:34` appears to be a penalty shootout timer, not game time

**Fix Applied:**
- Implemented `_looksLikeTime()` helper that checks for adjacent `:` or `.` characters
- Filters out space-separated candidates that look like time components
- Better clock/score disambiguation

**Current Result:**
- `homeTeam: RMA, awayTeam: BAY, score: 2 - 1, clock: 90:00`

---

### Issue 4: epl_02.png (new static sample)
**Raw OCR Text:**
```
ARS 0 0 WOL
24:35 Y.AF
```

**Outcome:**
- Parsed correctly without additional parser changes:
- `homeTeam: ARS, awayTeam: WOL, score: 0 - 0, clock: 24:35`

---

## Parser Strategy (Post-Fix)

Score detection strategy, in priority order:

### 1. Dash-Separated Format (Highest Confidence)
- Pattern: `\b(\d{1,3})\s*-\s*(\d{1,3})\b`
- Examples: `2 - 1`, `101 - 99`, `90+3' - 89'`
- Used when: Score has explicit dash separator

### 2. Space-Separated Format (Medium Confidence)
- Pattern: `\b(\d{1,3})\s+(\d{1,3})\b`
- Examples: `0 0`, `107 124`
- Filter: Skip candidates adjacent to `:` or `.` (likely part of time)
- Fallback: isolated standalone numbers if all candidates look time-like

### 3. TEAM SCORE TEAM SCORE Format (Structured Layout)
- Pattern: `\b([A-Z]{2,5})\s+(\d{1,3})\s+([A-Z]{2,5})\s+(\d{1,3})\b`
- Examples: `NOP 107 LAC 124`, `GS 64 CLE 85`
- Used when: Teams and scores are interspersed (sportscaster-style layout)

### 4. Fallback: Team Code Extraction
- Find all 2-5 letter words, take first and last as teams
- Used only if contextual extraction is missing/weak

### 5. Compact Clock-Between Pattern (Noisy OCR Layout)
- Pattern family handles: `TEAM noise SCORE CLOCK SCORE TEAM`
- Example: `MCI HESTER 0 89:10 0 TOT`
- Purpose: avoid score corruption from embedded clock tokens

---

## Clock Format Support

Updated clock regex now handles:
- Minutes with apostrophe: `45'`, `90+3'`
- Minutes and seconds: `1:23`, `2:59`, `:24`
- Decimal times (basketball): `49.8`, `2.5`
- Regex: `r"\b\d{1,3}(?:\+\d+)?'(?=\s|$)|\b\d{1,2}:\d{2}\b|:\d{2}\b|\b\d{1,2}\.\d{1,2}\b(?!\d)"`

---

## Tests Updated

All parser-focused tests are passing (8 total), including regressions:
1. Standard dash format: `"MAN UTD 2 - 1 CHELSEA 45'"`
2. Clock in mm:ss: `"LAL 101 - 99 BOS 1:23"`
3. Space-separated: `"MCI 0 0 TOT 89:10"`
4. TEAM SCORE TEAM SCORE: `"NOP 107 LAC 124 3rd 2:59 :24"`
5. Overlay detection: `"ARS 1 - 0 CITY 90+3' visit www.fake-stream.com"`
6. Noisy EPL compact text: `"MCI HESTER 0 89:10 0 TOT HE WORLD'S GAME FC24 MANCHE THE WORLD'S"`
7. Noisy banner EPL variant
8. UCL clock/score collision regression

---

## Next Steps

- Part 1 complete. Do not start Part 2 until Member B confirms stream readiness (Phase 3 Step 3.1).
