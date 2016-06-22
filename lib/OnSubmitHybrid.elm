module OnSubmitHybrid exposing
  ( Model
  , init
  , Msg
  , update
  , view
  )


import Html exposing (Html, Attribute, text, div, input, button)
import Html.App exposing (beginnerProgram)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onBlur, onClick)
import List
import String
import Validation exposing (..)

-- Model

type alias Field =
  { label : String
  , touched : Bool
  , focused : Bool
  , validation : (Validation String String)
  }

type alias Model =
  { firstName : Field
  , lastName : Field
  }

field : String -> Bool -> Bool -> String -> Field
field name touched focused value =
  Field name touched focused (validateName name value)

init : Model
init =
  Model
    (field "First name" False False "")
    (field "Surname" False False "")

-- Update

type Msg
  = Validate
  | UpdateFirstName FieldMsg
  | UpdateLastName FieldMsg

type FieldMsg
  = Change String
  | Blur

updateField : FieldMsg -> Field -> Field
updateField msg model =
  case msg of
    Change a ->
      { model
      | touched = True
      , validation = validateName model.label a
      }
    Blur ->
      { model
      | focused = True
      , touched = True
      }

update : Msg -> Model -> Model
update msg model =
  case msg of
    Validate ->
      { model
      | firstName = updateField Blur model.firstName
      , lastName = updateField Blur model.lastName
      }
    UpdateFirstName a ->
      { model | firstName = updateField a model.firstName }
    UpdateLastName a ->
      { model | lastName = updateField a model.lastName }

-- View

errorView : String -> Html Msg
errorView message =
  div [ class "help-block" ]
    [ text message
    ]

formClass : Field -> String
formClass { touched, focused, validation } =
  if touched then
    if focused && hasError validation then
      "form-group has-error"
    else if hasError validation then
      "form-group"
    else
      "form-group has-success"
  else
    "form-group"

messages : Field -> List (Html Msg)
messages { touched, focused, validation } =
  if touched && focused then
    List.map errorView (validationErrors validation)
  else
    []

fieldView : (FieldMsg -> Msg) -> Field -> Html Msg
fieldView tagger ({ label, validation } as field) =
  div [class (formClass field) ]
    [ Html.label [ class "control-label" ] [ text label ]
    , input [ class "form-control", onInput (Change >> tagger), value (validationValue validation) ] []
    , div [] (messages field)
    ]

view : Model -> Html Msg
view { firstName, lastName } =
  div [class "clearfix"]
    [ Html.form []
      [ fieldView UpdateFirstName firstName
      , fieldView UpdateLastName lastName
      ]
    , button [class "btn btn-primary pull-right", onClick Validate] [text "Validate"]
    ]
