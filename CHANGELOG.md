# Revision history for `liqwid-plutarch-extra` (aka "LPE")

This format is based on [Keep A Changelog](https://keepachangelog.com/en/1.0.0).

## 3.1.0 -- 2022-08-17

### Added

* `Plut` as a replacement for `Top`. This is specialized for kind `S -> Type`.

### Removed

* Uses of `generics-sop` in every module except `Plutarch.Extra.IsData`.

### Changed

* `since`s added to `Plutarch.Extra.Record` functions.
* `(.=)` no longer requires an `SListI` constraint.
* `DeriveGeneric`, `DeriveAnyClass` and `TypeFamilies` are on by default.

## 3.0.3 -- 2022-08-16

### Added

- `#.*`, `#.**`, `#.***` for plutarch function composition. They have similar 
  semantics as their counter parts in `Control.Composition`.
- `pfstTuple` and `psndTuple` for `PTuple`.
- Some orphan instances, including
  
  - `PIsData (PAsData a)`
  - `PTryFrom PData (PAsData PDatumHash)`
  - `PTryFrom PData (PAsData ScriptHash)`
  - `PTryFrom PData (PAsData PUnit)`

- Some useful functions to work with `POutputDatum`.

### Removed

- `pfindTxOutDatum`, please use `presolveOutputDatum` instead.

## 3.0.2 -- 2022-08-09

### Added
 - A `Plutarch.Extra.DebuggableScript` module, containing utilities for lazy
   compilation of scripts-with-tracing as a fallback when the script-without-tracing
   fails. This is useful for testing and benchmarking, since tracing is only turned on
   when error messages are actually needed.
 - A `Plutarch.Extra.Precompile` module, containing utilities for compiling
   scripts and arguments separately and applying them in various ways and from
   various types. This is useful for benchmarking and testing, since it will lead to
   performance increases and more accurate measurements of performance.

## 3.0.1 -- 2022-08-15

### Added

- `PBind` type class, for effect types with meaningful bind semantics. This is a
  direct equivalent to `Bind` from `semigroupoids`.
- `pjoin` and `#>>=`, as direct equivalents to `join` and `>>-` from
  `semigroupoids`, over `Term`s.
- Instances of `PBind` for `PMaybe`, `PMaybeData`, `PList`, `PBuiltinList`,
  `PPair s` (for semigroupal `s`), `PEither e`, `PIdentity` and `PState s`.
- Newtype `PStar` representing Kleisli arrows, as well as some helper functions.
- Instances of `PProfunctor`, `PSemigroupoid`, `PCategory`, `PFunctor`,
  `PApply`, `PApplicative`, `PBind` for `PStar` (in various parameterizations).

## 3.0.0 -- 2022-08-10

This major version bump includes updates to use plutus V2 (post-Vasil) API types.
We have decided that we will _not_ provide backports or updates for V1 API types
in the future.

Where re-exports from `Plutarch.Api.V1` exist, import from the `Plutarch.Api.V2`
modules have be made instead. This will not have any effect on client code, but
should clarify that these functions are indeed suitable for inclusion in V2 scripts.

### Modified
 - Nix flake points at a more recent version of nixpkgs, and temporarily points at a branch of `plutarch-quickcheck`
 - Names of modules referencing specific versions of the API (such as `Plutarch.Api.V1.AssetClass`) have been
   renamed to remove these references (i.e., becoming `Plutarch.Extra.AssetClass`). We will only support the
   more current API version in the future.
 - `pfindTxOutDatum` has been updated to work with V2 style datums (i.e., including a case for inline datums.)

### Removed
 - `plutarch-quickcheck` (aka PQ), which is a dependency of LPE, upgraded to V2 API types as part of a PR that also
   made major changes to its internals. See [here](https://github.com/Liqwid-Labs/plutarch-quickcheck/pull/26).
   As a result, some existing tests for LPE have been temporarily removed. [Issue #53](https://github.com/Liqwid-Labs/liqwid-plutarch-extra/issues/53)
   has been opened to port these tests to PQ2.0

## 2.0.2 -- 2022-08-08

### Changed

 - Scripts compiled with 'mustCompile' now enable deterministic tracing.

## 2.0.1 -- 2022-08-11

### Added

- `pjust` and `pnothing` for easier construction of `PJust` value.
- `pmaybe` which has the same semantics as `Data.Maybe.maybe`.

### Changed

- Rename the original `pamybe` to `pfromMaybe`.

## 2.0.0 -- 2022-08-02

### Added
 - A `Plutarch.Oprhans` module, holding downcasted instances of semigroup and monoid when the upcasted type has the appropriate instances.
 - `pflip` to `Plutarch.Extra.Function`
 - `Plutarch.Extra.IsData` a `PlutusTypeEnumData` as a deriving strategy for `PlutusType`
 - A `Plutarch.Extra.Compile` module, holding a `mustCompile` function to mimic the previous behavior of `compile`

### Changed

 - Update to [`Liqwid.nix`](https://github.com/liqwid-Labs/liqwid-nix)
 - Update to Plutarch version 1.2. See the [CHANGELOG](https://github.com/Plutonomicon/plutarch-plutus/blob/v1.2.0/CHANGELOG.md)
   for full details.
   - The flake now points at the `Plutonomicon` repository, instead of the Liqwid Labs fork.
   - Changes to deriving strategies and constraints may cause some API breakage. In particular,
     `deriving via`, `PMatch`, `PCon` has been eliminated, and redundant `PAsDAta`, `pfromData` have been reduced.

### Removed

 - The `Plutarch.Extra.Other` module has been removed. This held `deriving via` wrappers that are no longer necessary.
 - Tests relating to `Value`s and unsorted `Map`s, since `Plutarch 1.2` removed the `PEq` constraint on unsorted maps.

## 1.3.0 -- 2022-07-20

### Added

- `pmatchAll` and `pmatchAllC`, `pletFields` that gets all Plutarch record fields.
- `Plutarch.Extra.MultiSig`, a basic N of M multisignature validation function.
- `pscriptHashFromAddress`, gets script hash from an address.
- `pisScriptAddress`, checks if given address is script address.
- `pisPubKey`, checks if given credential is a pubkey hash.
- `pfindOutputsToAddress`, finds all TxOuts sent to an Address.
- `pfindTxOutDatum`, finds the data corresponding to a TxOut, if there is one.
- `phasOnlyOneTokenOfCurrencySymbol`, checks if entire value only contain one token of given currency symbol.
- `pon`, mirroring `Data.Function.on`.
- `pbuiltinUncurry`, mirroring `uncurry`.
- `pmaybeData`, mirroring `maybe` for `PMaybeData`.
- `pdjust` for easier construction of `PDJust` value.
- `pdnothing` for easier construction `PDNothing` value.

### Modified

- Fixed `PApplicative` instances that previously not worked due to not using `pfix`.
- Renamed `PType` to `S -> Type`.
- Renamed `mustBePJust` to `passertPJust`.
- Renamed `mustBePDJust` to `passertPDJust`.

## 1.2.0 -- 2022-07-12

### Added

- `PBoring` type class, representing singleton types.
- Instances of `PBoring` for various types.
- `preconst` for `PConst`, which allows safe coercions between different
  'pretend' types.
- `PSemiTraversable` instance for `PTagged`.
- `preplicateA` and `preplicateA_`, allowing for repeated execution of
  `PApplicative`.
- `pwhen` and `punless`, mirroring their Haskell counterparts.
- `preplicate`, mirroring its Haskell counterpart.

### Modified

- `PFunctor` now has a `pfconst` method as a back-end for `#$>` and `#<$`. This
  has a default implementation in terms of `pfmap`.
- `pvoid` can now replace every location with any `PBoring`, not just `PUnit`.
- `PTraversable` now has a `ptraverse_` method, which allows us to avoid
  rebuilding the `PTraversable` if we don't need it anymore. This allows much
  better folding, for example.
- `PSemiTraversable` now has a `psemitraverse_` method, with similar benefits to
  `ptraverse_`.
- `psemifold`, `psemifoldMap` and `psemifoldComonad` gained a `PSubcategory t a`
  constraint, as the 'container' is guaranteed non-empty in such a case.
- Significant performance improvements for `PTraversable` and `PSemiTraversable`
  instances.

## 1.1.0 -- 2022-06-17

### Added

- Convenience wrapper for `DerivePNewtype`: `DerivePNewtype'`, `DerivePConstantViaNewtype'`
- Encode product types as lists: `ProductIsData`, `DerivePConstantViaDataList`
- Encode enum types as integers: `EnumIsData`, `PEnumData` and `DerivePConstantViaEnum`
- Plutarch helper functions: `pmatchEnum`, `pmatchEnumFromData`

#### AssocMap (`Plutarch.Extra.Map`)

- `pupdate`
- `pmapMap` -> `pmap`

#### AssocMap (`Plutarch.Extra.Map.Sorted`)

- `pkeysEqual`
- `pmapUnionWith` -> `punionWith`

#### AssocMap (`Plutarch.Extra.Map.Unsorted`)

- `psort`
- `pkeysEqual`
- `pmapUnionWith` -> `punionWith`

#### Value (`Plutarch.Api.V1.Value`)

- `psymbolValueOf`
- `passetClassValueOf'`
- `pgeqByClass`
- `pgeqByClass'`
- `pgeqBySymbol`

#### Value (`Plutarch.Api.V1.Value.Unsorted`)

- `psort`

#### Maybe (`Plutarch.Extra.Maybe`)

- `pisJust`
- `pisDJust`
- `pfromMaybe`  -> `pmaybe`
- `tcexpectJust` (in `Plutarch.Extra.Maybe`) -> `pexpectJustC` (in `Plutarch.Extra.TermCont`)
- `pmaybeToMaybeData`

#### List (`Plutarch.Extra.List`)

- Re-exports from `plutarch-extra`
- `pnotNull`
- `pnubSortBy`/`pnubSort`
- `pisUniqueBy`/`pisUnique`
- `pmergeBy`
- `pmsortBy`/`pmsort`
- `pfindMap`->`pfirstJust`
- `plookup`
- `plookupTuple`
- `pfind'`
- `pfindMap` -> `pfirstJust`

#### `TermCont` (`Plutarch.Extra.TermCont`)

- Re-exports from `plutarch-extra`
- `tcassert` -> `passertC`
- `pguardWithC`
- 'pguardShowC'
- `tcexpectJust` (in `Plutarch.Extra.Maybe`) -> `pexpectJustC` (in `Plutarch.Extra.TermCont`)

#### Script Context (`Plutarch.Api.V1.ScriptContext`)

- `ptokenSpent` -> `pisTokenSpent`
- `pisUTXOSpent`
- `pvalueSpent`
- `ptxSignedBy`
- `ptryFindDatum`
- `pfindDatum`
- `pfindTxInByTxOutRef`

### Modified

- Rename `PConstantViaDataList` to `DerivePConstantViaDataList`

## 1.0.0 -- 2022-05-24

### Added

* First release
