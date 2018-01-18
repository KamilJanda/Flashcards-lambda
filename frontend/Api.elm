module Api exposing (..)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Json.Encode
import Http
import String


type alias FlashCard =
    { flashCardID : Maybe (String)
    , polishWord : String
    , englishWord : String
    }

decodeFlashCard : Decoder FlashCard
decodeFlashCard =
    decode FlashCard
        |> required "flashCardID" (maybe string)
        |> required "polishWord" string
        |> required "englishWord" string

encodeFlashCard : FlashCard -> Json.Encode.Value
encodeFlashCard x =
    Json.Encode.object
        [ ( "flashCardID", (Maybe.withDefault Json.Encode.null << Maybe.map Json.Encode.string) x.flashCardID )
        , ( "polishWord", Json.Encode.string x.polishWord )
        , ( "englishWord", Json.Encode.string x.englishWord )
        ]

getFlashcard : Http.Request (List (FlashCard))
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
            Http.expectJson (list decodeFlashCard)
        , timeout =
            Nothing
        , withCredentials =
            False
        }

postFlashcard : FlashCard -> Http.Request (FlashCard)
postFlashcard body =
    Http.request
        { method =
            "POST"
        , headers =
            []
        , url =
            String.join "/"
                [ "http://localhost:8000/api"
                , "flashcard"
                ]
        , body =
            Http.jsonBody (encodeFlashCard body)
        , expect =
            Http.expectJson decodeFlashCard
        , timeout =
            Nothing
        , withCredentials =
            False
        }