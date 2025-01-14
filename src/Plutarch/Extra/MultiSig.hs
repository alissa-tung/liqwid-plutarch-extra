{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE UndecidableInstances #-}

{- |
Module     : Plutarch.Extra.MultiSig
Maintainer : seungheon.ooh@gmail.com
Description: A basic N of M multisignature validation function.

A basic N of M multisignature validation function.
-}
module Plutarch.Extra.MultiSig (
    validatedByMultisig,
    pvalidatedByMultisig,
    PMultiSig (..),
    MultiSig (..),
) where

import GHC.Generics (Generic)
import Plutarch.Api.V2 (PPubKeyHash, PTxInfo)
import Plutarch.DataRepr (
    DerivePConstantViaData (DerivePConstantViaData),
    PDataFields,
    PlutusTypeData,
 )
import Plutarch.Extra.TermCont (pletFieldsC)
import Plutarch.Lift (PConstantDecl, PLifted, PUnsafeLiftDecl)
import Plutarch.Prelude (
    DerivePlutusType (DPTStrat),
    PAsData,
    PBool,
    PBuiltinList,
    PDataRecord,
    PInteger,
    PIsData,
    PLabeledType ((:=)),
    PlutusType,
    S,
    Term,
    pconstant,
    pelem,
    pfield,
    pfilter,
    pfromData,
    phoistAcyclic,
    plam,
    plength,
    unTermCont,
    (#),
    (#$),
    (#<=),
    type (:-->),
 )
import PlutusLedgerApi.V1.Crypto (PubKeyHash)
import qualified PlutusTx (makeLift, unstableMakeIsData)
import Prelude (Applicative (pure), Eq, Integer, Show, ($))

{- | A MultiSig represents a proof that a particular set of signatures
     are present on a transaction.

     @since 0.1.0
-}
data MultiSig = MultiSig
    { keys :: [PubKeyHash]
    -- ^ List of PubKeyHashes that must be present in the list of signatories.
    , minSigs :: Integer
    }
    deriving stock
        ( -- | @since 0.1.0
          Generic
        , -- | @since 0.1.0
          Eq
        , -- | @since 0.1.0
          Show
        )

PlutusTx.makeLift ''MultiSig
PlutusTx.unstableMakeIsData ''MultiSig

{- | Plutarch-level MultiSig

     @since 0.1.0
-}
newtype PMultiSig (s :: S) = PMultiSig
    { getMultiSig ::
        Term
            s
            ( PDataRecord
                '[ "keys" ':= PBuiltinList (PAsData PPubKeyHash)
                 , "minSigs" ':= PInteger
                 ]
            )
    }
    deriving stock
        ( -- | @since 0.1.0
          Generic
        )
    deriving anyclass
        ( -- | @since 0.1.0
          PlutusType
        , -- | @since 0.1.0
          PIsData
        , -- | @since 0.1.0
          PDataFields
        )

-- | @since 1.4.0
instance DerivePlutusType PMultiSig where
    type DPTStrat _ = PlutusTypeData

-- | @since 0.1.0
instance PUnsafeLiftDecl PMultiSig where
    type PLifted PMultiSig = MultiSig

-- | @since 0.1.0
deriving via
    (DerivePConstantViaData MultiSig PMultiSig)
    instance
        (PConstantDecl MultiSig)

--------------------------------------------------------------------------------

{- | Check if a Haskell-level MultiSig signs this transaction.

     @since 0.1.0
-}
validatedByMultisig :: forall (s :: S). MultiSig -> Term s (PTxInfo :--> PBool)
validatedByMultisig params =
    phoistAcyclic $
        pvalidatedByMultisig # pconstant params

{- | Check if a Plutarch-level MultiSig signs this transaction.

     @since 0.1.0
-}
pvalidatedByMultisig :: forall (s :: S). Term s (PMultiSig :--> PTxInfo :--> PBool)
pvalidatedByMultisig =
    phoistAcyclic $
        plam $ \multi' txInfo -> unTermCont $ do
            multi <- pletFieldsC @'["keys", "minSigs"] multi'
            let signatories = pfield @"signatories" # txInfo
            pure $
                pfromData multi.minSigs
                    #<= ( plength #$ pfilter
                            # plam
                                ( \a ->
                                    pelem # a # pfromData signatories
                                )
                            # multi.keys
                        )
