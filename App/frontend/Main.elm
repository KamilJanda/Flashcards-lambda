module Main exposing (..)

import Html exposing (Html, div, text, program, button, h1, h2, input, Attribute)
import Api exposing (..)
import Http
import Array
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


-- MODEL


type alias Model =
    {flashCards : List Api.FlashCard
    , newPolishWord : String
    , newEnglishWord : String
    , quesedEnglishWord : String
    , response : String
    , currentFlashCard : Int
    }

isNotEmpty : Model -> Bool
isNotEmpty model =
  model.newPolishWord /= "" && model.newEnglishWord /= ""

getEnglishWord : Maybe FlashCard -> String
getEnglishWord fc =
  case fc of
    Nothing -> ""
    Just flashCard -> flashCard.englishWord

getPolishWord : Maybe FlashCard -> String
getPolishWord fc =
  case fc of
    Nothing -> ""
    Just flashCard -> flashCard.polishWord

checkIfSame : String -> String -> String
checkIfSame s1 s2 =  if s1 == s2 then "Correct!" else "Wrong"

getCurrentFlashCard : Model -> Maybe Api.FlashCard
getCurrentFlashCard model =
  let arr = Array.fromList model.flashCards
  in Array.get model.currentFlashCard arr

init : ( Model, Cmd Msg )
init =
    ( initModel, fetch )


initModel : Model
initModel =
    { flashCards = []
    , newPolishWord = ""
    , newEnglishWord = ""
    , quesedEnglishWord = ""
    , currentFlashCard = 0
    , response = ""
    }


-- MESSAGES


type Msg
    = Fetch
    | SetFlashCards (Result Http.Error (List Api.FlashCard))
    | Next
    | Previous
    | Reset
    | Change String
    | Check
    | ChangeEnglishWord String
    | ChangePolishWord String
    | Add



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [text "Flash Card Alpha"]
        , viewTester model
        , viewAddFC model
        ]

viewTester model =
  div [] [
     h2 [] [text  ("Guess this word meaning: " ++ getPolishWord(getCurrentFlashCard model))]
    , div [] [ input [ placeholder "guesed english word", onInput Change ] []
             ,button [ onClick Check ] [ text "check" ]
             , text model.response
             ]
    , div [] [button [ onClick Previous ] [ text "previous" ]
              ,button [ onClick Next ] [ text "next" ]
              ,button [ onClick Reset ] [ text "reset" ]
              ]
    ]

viewAddFC model =
    div [] [ h2 [] [ text ("Add new Flash Card!")]
            ,  input [ placeholder "new english word", onInput ChangeEnglishWord ] []
            ,  input [ placeholder "new polish word", onInput ChangePolishWord ] []
            , button [ onClick Add ] [ text "add" ]
            ]
-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      -- it might seem usless but too keep same return same value this option is created
      -- if you are looking for example take a peek at Add
        Fetch -> ( model, fetch)

        SetFlashCards nfc ->
          ({ model | flashCards = Result.withDefault model.flashCards nfc }, Cmd.none)

        Next -> (
          (if model.currentFlashCard + 1 < List.length model.flashCards then
            let temp = model.currentFlashCard in
            {model | currentFlashCard = temp +1 }
            else
              model
          ),Cmd.none)

        Previous -> (
          (if model.currentFlashCard > 0 then
            let temp = model.currentFlashCard in
            {model | currentFlashCard = temp - 1 }
            else
              model
          ),Cmd.none)

        Reset -> ({model | currentFlashCard = 0}, Cmd.none)

        Change newWord -> ({model | quesedEnglishWord = newWord}, Cmd.none)

        ChangeEnglishWord newWord -> ({model | newPolishWord = newWord}, Cmd.none)

        ChangePolishWord newWord -> ({model | newEnglishWord = newWord}, Cmd.none)

        Check ->  ({model |response = checkIfSame (getEnglishWord (getCurrentFlashCard model))
                      model.quesedEnglishWord}, Cmd.none)

        Add ->
          if isNotEmpty model then
            ({ model | newPolishWord = "", newEnglishWord="" },
            postFlashcard
            {
              flashCardID = Nothing
            , polishWord = model.newPolishWord
            , englishWord = model.newEnglishWord
            }
            |> Http.send (\_ -> Fetch)
            )
          else
            (model, Cmd.none)


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
