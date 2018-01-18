module Api exposing (..)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Json.Encode
import Http
import String


type alias FlashCard =
    { polishWord : String
    , englishWord : String
    }

decodeFlashCard : Decoder FlashCard
decodeFlashCard =
    decode FlashCard
        |> required "polishWord" string
        |> required "englishWord" string

encodeFlashCard : FlashCard -> Json.Encode.Value
encodeFlashCard x =
    Json.Encode.object
        [ ( "polishWord", Json.Encode.string x.polishWord )
        , ( "englishWord", Json.Encode.string x.englishWord )
        ]

getFlashcard : Http.Request (FlashCard)
getFlashcard =
    Http.request
        { method =
            "GET"
        , headers =
            []
        , url =
            String.join "/"
                [ "http://localhost:8000/api"
                , "flashcard"
                ]
        , body =
            Http.emptyBody
        , expect =
            Http.expectJson decodeFlashCard
        , timeout =
            Nothing
        , withCredentials =
            False
        }