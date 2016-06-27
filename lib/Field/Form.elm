module Field.Form exposing (..)

import Html exposing (Html, text, div, button)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

view : msg -> List (Html msg) -> Html msg
view tagger fields =
  div [class "clearfix"]
    [ Html.form [] fields
    , button [class "btn btn-primary pull-right", onClick tagger] [text "Continue"]
    ]
