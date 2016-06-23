module Field exposing
  ( Model
  , init
  , Msg
  , validate
  , blur
  , noop
  , update
  , fieldGroup
  , input
  , form
  )


import Html exposing (Html, Attribute, text, div, button)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onBlur, onClick)
import List
import String
import Validation exposing (..)


-- Model

type alias Model =
  { label : String
  , touched : Bool
  , focused : Bool
  , validation : (Validation String String)
  }

field : String -> Bool -> Bool -> String -> Model
field name touched focused value =
  Model name touched focused (validateName name value)

init : String -> Model
init name = field name False False ""

type Msg
  = Change String
  | Blur
  | Validate
  | Noop

validate : Msg
validate = Validate

blur : Msg
blur = Blur

noop : Msg
noop = Noop

update : Msg -> Model -> Model
update msg model =
  case msg of
    Change a ->
      { model
      | validation = validateName model.label a
      , touched = True
      }
    Blur ->
      { model
      | focused = True
      }
    Validate ->
      { model
      | focused = True
      , touched = True
      }
    Noop -> model

-- View

errorView : String -> Html Msg
errorView message =
  div [ class "help-block" ]
    [ text message
    ]

formClass : Model -> String
formClass { touched, focused, validation } =
  if touched && focused then
    if focused && hasError validation then
      "form-group has-error"
    else if hasError validation then
      "form-group"
    else
      "form-group has-success"
  else
    "form-group"

messages : Model -> List (Html Msg)
messages { touched, focused, validation } =
  if touched && focused then
    List.map errorView (validationErrors validation)
  else
    []

input : Msg -> Model -> Html Msg
input blur { validation } =
  Html.input
    [ class "form-control"
    , onInput Change
    , onBlur blur
    , value (validationValue validation)
    ]
    []

fieldGroup : Model -> Html Msg -> Html Msg
fieldGroup ({ label, validation } as field) input =
  div [class (formClass field) ]
    [ Html.label [ class "control-label" ] [ text label ]
    , input
    , div [] (messages field)
    ]

form : msg -> List (Html msg) -> Html msg
form tagger fields =
  div [class "clearfix"]
    [ Html.form []
      fields
    , button [class "btn btn-primary pull-right", onClick tagger] [text "Continue"]
    ]
