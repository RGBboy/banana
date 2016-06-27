module OnSubmit exposing
  ( Model
  , init
  , Msg
  , update
  , view
  )


import Html exposing (Html, div, text)
import Html.App as App
import Field
import Field.Input as Input
import Field.DateFocus as DateFocus
import Field.Form as Form
import Field.FieldGroup as FieldGroup

import Validation

dateId : Maybe String
dateId = Just "date"

-- Model

type alias Model =
  { submitted : Bool
  , title : Field.Model
  , firstName : Field.Model
  , lastName : Field.Model
  , companyName : Field.Model
  , telephone : Field.Model
  , date : { input : DateFocus.Model, field: Field.Model }
  }

init : Model
init =
  let
    dateInput = (DateFocus.init dateId)
  in
    Model
      False
      (Field.init "Title" "" Validation.success "")
      (Field.init "First name" "" Validation.name "")
      (Field.init "Last name" "" Validation.name "")
      (Field.init "Company name" "" Validation.company "")
      (Field.init "Telephone" "" Validation.success "")
      { input = dateInput
      , field = (Field.init "Date of birth" "(DD MM YYYY)" Validation.success dateInput.value )
      }

-- Update

type Msg
  = Validate
  | UpdateTitle Field.Msg
  | UpdateFirstName Field.Msg
  | UpdateLastName Field.Msg
  | UpdateCompanyName Field.Msg
  | UpdateTelephone Field.Msg
  | UpdateDate DateFocus.Msg

update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    Validate ->
      let
        title = Field.update Field.validate model.title
        firstName = Field.update Field.validate model.firstName
        lastName = Field.update Field.validate model.lastName
        companyName = Field.update Field.validate model.companyName
        telephone = Field.update Field.validate model.telephone
        dateField = Field.update Field.validate model.date.field
        submitted =
          Field.isOk title &&
          Field.isOk firstName &&
          Field.isOk lastName &&
          Field.isOk companyName &&
          Field.isOk telephone &&
          Field.isOk dateField
      in
        ( Model
            submitted
            title
            firstName
            lastName
            companyName
            telephone
            { input = model.date.input
            , field = dateField
            }
        , Cmd.none
        )
    UpdateTitle a ->
      ( { model | title = Field.update a model.title }
      , Cmd.none
      )
    UpdateFirstName a ->
      ( { model | firstName = Field.update a model.firstName }
      , Cmd.none
      )
    UpdateLastName a ->
      ( { model | lastName = Field.update a model.lastName }
      , Cmd.none
      )
    UpdateCompanyName a ->
      ( { model | companyName = Field.update a model.companyName }
      , Cmd.none
      )
    UpdateTelephone a ->
      ( { model | telephone = Field.update a model.telephone }
      , Cmd.none
      )
    UpdateDate a ->
      let
        date = model.date
        (newInput, cmd) = DateFocus.update a model.date.input
        newDate =
          { date
          | input = newInput
          , field = Field.update (Field.Change newInput.value) model.date.field
          }
      in
        ( { model | date = newDate }
        , cmd
        )

-- View

view : Model -> Html Msg
view { submitted, title, firstName, lastName, companyName, telephone, date } =
  if submitted then
    div [] [ text "Thanks!" ]
  else
    Form.view Validate
      [ App.map UpdateTitle
          ( FieldGroup.view title
              (Input.viewSmall Field.noop title.value)
          )
      , App.map UpdateFirstName
          ( FieldGroup.view firstName
              (Input.view Field.noop firstName.value)
          )
      , App.map UpdateLastName
          ( FieldGroup.view lastName
              (Input.view Field.noop lastName.value)
          )
      , App.map UpdateCompanyName
          ( FieldGroup.view companyName
              (Input.view Field.noop companyName.value)
          )
      , App.map UpdateTelephone
          ( FieldGroup.view telephone
              (Input.view Field.noop telephone.value)
          )
      , App.map UpdateDate
          ( FieldGroup.view date.field
              (DateFocus.view date.input)
          )
      ]
