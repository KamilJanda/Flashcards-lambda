{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators     #-}

module Generator where

import           Data.Proxy  (Proxy (Proxy))
import           Elm         (Spec (Spec), specsToDir, toElmTypeSource,
                              toElmDecoderSource, toElmEncoderSource)
import           Servant.Elm (ElmOptions (..), defElmImports, defElmOptions,
                              generateElmForAPIWith, UrlPrefix (Static))

import           Lib(FlashCard, Api)

elmOpts :: ElmOptions
elmOpts =
  defElmOptions
    { urlPrefix = Static "http://localhost:8000/api" }

specs :: [Spec]
specs =
  [ Spec ["Api"]
         (defElmImports
          : toElmTypeSource    (Proxy :: Proxy FlashCard)
          : toElmDecoderSource (Proxy :: Proxy FlashCard)
          : toElmEncoderSource (Proxy :: Proxy FlashCard)
          : generateElmForAPIWith elmOpts  (Proxy :: Proxy Api))
  ]

generate :: IO ()
generate = specsToDir specs "generated"
