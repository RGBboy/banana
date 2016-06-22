module OnChange exposing
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
  { label : String
  , touched : Bool
  , validation : (Validation String String)
  }

type alias Model =
  { firstName : Field
  , lastName : Field
  }

field : String -> Bool -> String -> Field
field name touched value =
  Field name touched (validateName name value)

init : Model
init =
  Model
    (field "First name" False "")
    (field "Surname" False "")

-- Update

type Msg
  = UpdateFirstName String
  | UpdateLastName String

update : Msg -> Model -> Model
update msg model =
  case msg of
    UpdateFirstName a ->
      { model | firstName = (field "First name" True a) }
    UpdateLastName a ->
      { model | lastName = (field "Surname" True a) }

-- View

errorView : String -> Html Msg
errorView message =
  div [ class "help-block" ]
    [ text message
    ]

formClass : Field -> String
formClass { touched, validation } =
  if touched then
    if hasError validation then
      "form-group has-error"
    else
      "form-group has-success"
  else
    "form-group"

messages : Field -> List (Html Msg)
messages { touched, validation } =
  if touched then
    List.map errorView (validationErrors validation)
  else
    []

fieldView : (String -> Msg) -> Field -> Html Msg
fieldView tagger ({ label, validation } as field) =
  div [class (formClass field) ]
    [ Html.label [ class "control-label" ] [ text label ]
    , input [ class "form-control", onInput tagger, value (validationValue validation) ] []
    , div [] (messages field)
    ]

view : Model -> Html Msg
view { firstName, lastName } =
  Html.form []
    [ fieldView UpdateFirstName firstName
    , fieldView UpdateLastName lastName
    ]
