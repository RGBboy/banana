module Basic exposing
  ( Model
  , init
  , Msg
  , update
  , view
  )


import Html exposing (Html, Attribute, text, div, input)
import Html.App exposing (beginnerProgram)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import List
import String
import Validation exposing (..)


-- Model

type alias Field =
  { label: String
  , validation: (Validation String String)
  }

type alias Model =
  { firstName : Field
  , lastName : Field
  }

field : String -> String -> Field
field name value =
  Field name (validateName name value)

init : Model
init =
  Model
    (field "First name" "")
    (field "Surname" "")

-- Update

type Msg
  = UpdateFirstName String
  | UpdateLastName String

update : Msg -> Model -> Model
update msg model =
  case msg of
    UpdateFirstName a ->
      { model | firstName = (field "First name" a) }
    UpdateLastName a ->
      { model | lastName = (field "Surname" a) }

-- View

errorView : String -> Html Msg
errorView message =
  div [ class "help-block" ]
    [ text message
    ]

fieldView : (String -> Msg) -> Field -> Html Msg
fieldView tagger { label, validation } =
  let
    formClass =
      if hasError validation then
        "form-group has-error"
      else
        "form-group has-success"
  in
    div [class formClass]
      [ Html.label [ class "control-label" ] [ text label ]
      , input [ class "form-control", onInput tagger, value (validationValue validation) ] []
      , div [] (List.map errorView (validationErrors validation))
      ]

view : Model -> Html Msg
view { firstName, lastName } =
  Html.form []
    [ fieldView UpdateFirstName firstName
    , fieldView UpdateLastName lastName
    ]
