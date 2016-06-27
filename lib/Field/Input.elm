module Field.Input exposing (..)


import Html exposing (Html, Attribute, text, div, button)
import Html.App as App
import Html.Attributes as A exposing (..)
import Html.Events exposing (onInput, onBlur, onClick)
import List
import String
import Field

-- View

viewSmall : Field.Msg -> String -> Html Field.Msg
viewSmall blur value =
  Html.input
    [ class "form-control"
    , style [ ("width", "25%") ]
    , onInput Field.Change
    , type' "text"
    , onBlur blur
    , A.value value
    ]
    []

view : Field.Msg -> String -> Html Field.Msg
view blur value =
  Html.input
    [ class "form-control"
    , onInput Field.Change
    , type' "text"
    , onBlur blur
    , A.value value
    ]
    []

viewTelephone : Field.Msg -> String -> Html Field.Msg
viewTelephone blur value =
  Html.input
    [ class "form-control"
    , onInput Field.Change
    , type' "tel"
    , onBlur blur
    , A.value value
    ]
    []
