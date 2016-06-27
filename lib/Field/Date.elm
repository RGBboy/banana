module Field.Date exposing (..)


import Html exposing (Html, text, div, input)
import Html.Attributes as A exposing (..)
import Html.Events exposing (onInput)
import String
import Char


-- Model

type alias Model = String

init : Model
init = "//"

updateDay : Date -> String -> String
updateDay (_, m, y) d =
  applyMask (d, m, y)

updateMonth : Date -> String -> String
updateMonth (d, _, y) m =
  applyMask (d, m, y)

updateYear : Date -> String -> String
updateYear (d, m, _) y =
  applyMask (d, m, y)

type alias Date = (String, String, String)

removeMask : String -> Date
removeMask a =
  case (String.split "/" a) of
    [] -> ("", "", "")
    d :: [] -> (d, "", "")
    d :: m :: [] -> (d, m, "")
    d :: m :: y :: _ -> (d, m, y)

applyMask : Date -> String
applyMask (d, m, y) = d ++ "/" ++ m ++ "/" ++ y

-- View

view : (String -> msg) -> Model -> Html msg
view change v =
  let
    date = removeMask v
    (day, month, year) = date
  in
    div [ class "form-inline"]
      [ input
          [ class "form-control"
          , style [ ("width", "3em"), ("display", "inline"), ("padding", "6px"), ("text-align", "center" ) ]
          , type' "tel"
          , onInput (updateDay date >> change)
          , value day
          ]
          []
      , text " "
      , input
          [ class "form-control"
          , style [ ("width", "3em"), ("display", "inline"), ("padding", "6px"), ("text-align", "center" ) ]
          , type' "tel"
          , onInput (updateMonth date >> change)
          , value month
          ]
          []
      , text " "
      , input
          [ class "form-control"
          , style [ ("width", "5em"), ("display", "inline"), ("padding", "6px"), ("text-align", "center" ) ]
          , type' "tel"
          , onInput (updateYear date >> change)
          , value year
          ]
          []
      ]
