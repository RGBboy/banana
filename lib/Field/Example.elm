import Html exposing (Html, div)
import Html.App as App
import String

import Field.Date as Date
import Field.DateFocus as DateFocus

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }


-- MODEL

type alias Model =
  { date : Date.Model
  , dateFocus : DateFocus.Model
  }

model : Model
model =
  { date = Date.init
  , dateFocus = DateFocus.init (Just "test")
  }

init : (Model, Cmd Msg)
init = (model, Cmd.none)

-- UPDATE

type Msg
  = UpdateDate String
  | UpdateDateFocus DateFocus.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateDate a ->
      ( { model | date = a }
      , Cmd.none
      )
    UpdateDateFocus a ->
      let
        (newDateFocus, cmd) = DateFocus.update a model.dateFocus
      in
        ( { model | dateFocus = newDateFocus }
        , Cmd.map UpdateDateFocus cmd
        )


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ Date.view UpdateDate model.date
    , App.map UpdateDateFocus (DateFocus.view model.dateFocus)
    ]
