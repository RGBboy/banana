

import Html exposing (Html, text, div, h2, button, hr)
import Html.App as App
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

import Navigation exposing (Location, Parser, makeParser)

import String

import OnFocus
import OnSubmit



main : Program Never
main =
  Navigation.program
    parser
    { init = init
    , urlUpdate = urlUpdate
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

-- Model

type alias Model =
  { hash: String
  , onFocus : OnFocus.Model
  , onSubmit : OnSubmit.Model
  }

initModel : String -> Model
initModel hash =
  Model
    hash
    OnFocus.init
    OnSubmit.init

init : String -> (Model, Cmd Msg)
init hash =
  ( initModel hash
  , Cmd.none
  )

-- Update

type Msg
  = Reset
  | UpdateOnFocus OnFocus.Msg
  | UpdateOnSubmit OnSubmit.Msg

hash : Location -> String
hash location =
  String.dropLeft 1 location.hash

parser : Parser String
parser = makeParser hash

urlUpdate : String -> Model -> (Model, Cmd Msg)
urlUpdate hash model =
  ( { model | hash = hash }
  , Cmd.none
  )

updateModel : Msg -> Model -> Model
updateModel msg model =
  case msg of
    Reset -> initModel model.hash
    UpdateOnFocus a ->
      { model | onFocus = OnFocus.update a model.onFocus }
    UpdateOnSubmit a ->
      { model | onSubmit = OnSubmit.update a model.onSubmit }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  (updateModel msg model, Cmd.none)


-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- View


view : Model -> Html Msg
view model =
  if model.hash == "B" then
    div [class "app"]
      [ h2 []
        [ text "B"
        , button [ class "btn btn-primary pull-right", onClick Reset ] [ text "Reset" ]
        ]
      , App.map UpdateOnFocus (OnFocus.view model.onFocus)
      ]
  else
    div [class "app"]
      [ h2 []
        [ text "A"
        , button [ class "btn btn-primary pull-right", onClick Reset ] [ text "Reset" ]
        ]
      , App.map UpdateOnSubmit (OnSubmit.view model.onSubmit)
      ]
