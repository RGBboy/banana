module OnFocus exposing
  ( Model
  , init
  , Msg
  , update
  , view
  )


import Html exposing (Html)
import Html.App as App
import Field

-- Model

type alias Model =
  { firstName : Field.Model
  , lastName : Field.Model
  }

init : Model
init =
  Model
    (Field.init "First name")
    (Field.init "Surname")

-- Update

type Msg
  = Validate
  | UpdateFirstName Field.Msg
  | UpdateLastName Field.Msg

update : Msg -> Model -> Model
update msg model =
  case msg of
    Validate ->
      { model
      | firstName = Field.update Field.validate model.firstName
      , lastName = Field.update Field.validate model.lastName
      }
    UpdateFirstName a ->
      { model | firstName = Field.update a model.firstName }
    UpdateLastName a ->
      { model | lastName = Field.update a model.lastName }

-- View

view : Model -> Html Msg
view { firstName, lastName } =
  Field.form Validate
    [ App.map UpdateFirstName
        ( Field.fieldGroup firstName
            (Field.input Field.blur firstName)
        )
    , App.map UpdateLastName
        ( Field.fieldGroup lastName
            (Field.input Field.blur lastName)
        )
    ]
