module Main exposing (..)

import Html exposing (Html, div, text, program)
import Api exposing (..)
import Http

-- MODEL


type alias Model =
    {flashCards : List Api.FlashCard
    , newPolishWord : String
    , newEnglishWord : String
    , currentFlashCard : Int
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, fetch )


initModel : Model
initModel =
    { flashCards = []
    , newPolishWord = ""
    , newEnglishWord = "n"
    , currentFlashCard = 0 }


-- MESSAGES


type Msg
    = Fetch
    | SetFlashCards (Result Http.Error (List Api.FlashCard))



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text (toString model) ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Fetch ->
          ( model, fetch)

        SetFlashCards nfc ->
          ({ model | flashCards = Result.withDefault model.flashCards nfc }, Cmd.none)


fetch : Cmd Msg
fetch =
  getFlashcard
    |> Http.send SetFlashCards

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
