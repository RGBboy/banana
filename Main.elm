
import Html exposing (Html, text, div, h2, button)
import Html.App exposing (beginnerProgram, map)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

import Basic
import OnChange
import OnFocus
import Hybrid

main : Program Never
main =
  beginnerProgram
    { model = init
    , view = view
    , update = update
    }

-- Model

type alias Model =
  { basic : Basic.Model
  , onChange : OnChange.Model
  , onFocus : OnFocus.Model
  , hybrid : Hybrid.Model
  }

init : Model
init =
  Model
    Basic.init
    OnChange.init
    OnFocus.init
    Hybrid.init

-- Update

type Msg
  = Reset
  | UpdateBasic Basic.Msg
  | UpdateOnChange OnChange.Msg
  | UpdateOnFocus OnFocus.Msg
  | UpdateHybrid Hybrid.Msg

update : Msg -> Model -> Model
update msg model =
  case msg of
    Reset -> init
    UpdateBasic a ->
      { model | basic = Basic.update a model.basic }
    UpdateOnChange a ->
      { model | onChange = OnChange.update a model.onChange }
    UpdateOnFocus a ->
      { model | onFocus = OnFocus.update a model.onFocus }
    UpdateHybrid a ->
      { model | hybrid = Hybrid.update a model.hybrid }

-- View

view : Model -> Html Msg
view model =
  div [class "app"]
    [ h2 []
      [ text "Basic"
      , button [ class "btn btn-primary pull-right", onClick Reset ] [ text "Reset" ]
      ]
    , map UpdateBasic (Basic.view model.basic)
    , h2 []
      [ text "OnChange"
      , button [ class "btn btn-primary pull-right", onClick Reset ] [ text "Reset" ]
      ]
    , map UpdateOnChange (OnChange.view model.onChange)
    , h2 []
      [ text "OnFocus"
      , button [ class "btn btn-primary pull-right", onClick Reset ] [ text "Reset" ]
      ]
    , map UpdateOnFocus (OnFocus.view model.onFocus)
    , h2 []
      [ text "Hybrid"
      , button [ class "btn btn-primary pull-right", onClick Reset ] [ text "Reset" ]
      ]
    , map UpdateHybrid (Hybrid.view model.hybrid)
    ]
