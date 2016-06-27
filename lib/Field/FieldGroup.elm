module Field.FieldGroup exposing (..)


import Html exposing (Html, text, div, button)
import Html.App as App
import Html.Attributes exposing (..)
import String
import List
import Validation exposing (Validation)

import Field

errorView : String -> Html msg
errorView message =
  div [ class "help-block" ]
    [ text message
    ]

formClass : Bool -> Bool -> List String -> String
formClass touched focused errors =
  let
    hasErrors = (List.length errors > 0)
  in
    if touched && focused then
      if focused && hasErrors then
        "form-group has-error"
      else if hasErrors then
        "form-group"
      else
        "form-group"
    else
      "form-group"

messages : Bool -> Bool -> List String -> List (Html msg)
messages touched focused errors =
  if touched && focused then
    List.map errorView errors
  else
    []

view : Field.Model -> Html msg -> Html msg
view ({ name, help, touched, focused, validate, value } as field) input =
  let
    validation = validate name value
    errors = Validation.errors validation
    labelText = Html.label [ class "control-label" ] [ text name ]
    helpText =
      if String.isEmpty help then
        []
      else
        [Html.span [ class "help-block"] [ text help ]]
    children = List.append (labelText :: helpText)
      [ input
      , div [] (messages touched focused errors)
      ]
  in
    div [class (formClass touched focused errors)] children
