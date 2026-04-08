# Audit: swift-incits-4-1986

## Legacy — Consolidated 2026-04-08

### From: swift-institute/Research/audit-standards-p2.md (2026-04-03)

**Pre-publication audit — P0/P1/P2 checks**

#### P0: Foundation Imports [PRIM-FOUND-001]

**Result: PASS** — No `import Foundation` in any Sources/ directory.

#### P1: Multi-Type Files [API-IMPL-005]

**Result: PASS** — Each file declares exactly one type (or one extension with no new type declarations).

#### P1: Compound Type Names [API-NAME-001]

**Result: FAIL — 7 types (3 local enums + 4 typealiases)**

| # | Severity | Rule | Location | Finding | Action |
|---|----------|------|----------|---------|--------|
| 1 | P1 | API-NAME-001 | `Sources/.../INCITS_4_1986.ByteArrayClassification.swift:26` | `ByteArrayClassification` — compound name | Rename to `Byte.Array.Classification` or `Byte.Classification` |
| 2 | P1 | API-NAME-001 | `Sources/.../INCITS_4_1986.StringClassification.swift:17` | `StringClassification` — compound name | Rename to `String.Classification` |
| 3 | P1 | API-NAME-001 | `Sources/.../INCITS_4_1986.LineEndingDetection.swift:19` | `LineEndingDetection` — compound name | Rename to `Line.Ending.Detection` or `FormatEffectors.Line.Ending.Detection` |
| 4 | P1 | API-NAME-001 | `Sources/.../INCITS_4_1986.FormatEffectors.swift:12` | `FormatEffectors` — compound name | Rename to `Format.Effectors` (matches spec section "Format Effectors") |
| 5 | P1 | API-NAME-001 | `Sources/.../INCITS_4_1986.NumericParsing.swift:11` | `NumericParsing` (typealias) — compound name | Rename to `Numeric.Parsing` |
| 6 | P1 | API-NAME-001 | `Sources/.../INCITS_4_1986.NumericSerialization.swift:11` | `NumericSerialization` (typealias) — compound name | Rename to `Numeric.Serialization` |
| 7 | P1 | API-NAME-001 | `Sources/.../INCITS_4_1986.CharacterClassification.swift:11` | `CharacterClassification` (typealias) — compound name | Rename to `Character.Classification` (note: `Character` is already a typealias — may conflict) |

**Note**: Typealiases #5-#7 originate upstream in `ASCII_Primitives.ASCII.*`. The compound naming issue partially originates in the primitives layer. The 3 locally-declared enums (#1-#3) are straightforward local fixes.

#### P2: Methods in Type Bodies [API-IMPL-008]

**Result: PASS** — No violations.

#### P3: Missing Doc Comments [DOC-001]

**Result: PASS** — All public declarations have doc comments.

#### Additional Observations

- **Filename inconsistency**: `NCITS_4_1986.FormatEffectors.LineEnding.swift` uses prefix `NCITS` instead of `INCITS`. The type inside correctly uses `INCITS_4_1986`. Historical artifact (NCITS was the previous name before the standards body became INCITS). Path: `Sources/INCITS_4_1986/NCITS_4_1986.FormatEffectors.LineEnding.swift`. Action: rename file to `INCITS_4_1986.FormatEffectors.Line.swift`.

#### Summary

| Check | Result | Count |
|-------|--------|-------|
| P0: Foundation imports | PASS | 0 |
| P1: Multi-type files | PASS | 0 |
| P1: Compound type names | FAIL | 7 types |
| P2: Methods in type bodies | PASS | 0 |
| P3: Missing doc comments | PASS | 0 |
