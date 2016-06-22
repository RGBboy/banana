
import Html exposing (Html, text, div, h2, button, hr)
import Html.App exposing (beginnerProgram, map)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

import Basic
import OnChange
import OnFocus
import Hybrid
import OnSubmit
import OnSubmitHybrid

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
  , onSubmit : OnSubmit.Model
  , onSubmitHybrid : OnSubmitHybrid.Model
  }

init : Model
init =
  Model
    Basic.init
    OnChange.init
    OnFocus.init
    Hybrid.init
    OnSubmit.init
    OnSubmitHybrid.init

-- Update

type Msg
  = Reset
  | UpdateBasic Basic.Msg
  | UpdateOnChange OnChange.Msg
  | UpdateOnFocus OnFocus.Msg
  | UpdateHybrid Hybrid.Msg
  | UpdateOnSubmit OnSubmit.Msg
  | UpdateOnSubmitHybrid OnSubmitHybrid.Msg

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
    UpdateOnSubmit a ->
      { model | onSubmit = OnSubmit.update a model.onSubmit }
    UpdateOnSubmitHybrid a ->
      { model | onSubmitHybrid = OnSubmitHybrid.update a model.onSubmitHybrid }

-- View

view : Model -> Html Msg
view model =
  div [class "app"]
    [ h2 []
      [ text "Basic"
      , button [ class "btn btn-primary pull-right", onClick Reset ] [ text "Reset" ]
      ]
    , map UpdateBasic (Basic.view model.basic)
    , hr [] []
    , h2 []
      [ text "OnChange"
      , button [ class "btn btn-primary pull-right", onClick Reset ] [ text "Reset" ]
      ]
    , map UpdateOnChange (OnChange.view model.onChange)
    , hr [] []
    , h2 []
      [ text "OnFocus"
      , button [ class "btn btn-primary pull-right", onClick Reset ] [ text "Reset" ]
      ]
    , map UpdateOnFocus (OnFocus.view model.onFocus)
    , hr [] []
    , h2 []
      [ text "Hybrid"
      , button [ class "btn btn-primary pull-right", onClick Reset ] [ text "Reset" ]
      ]
    , map UpdateHybrid (Hybrid.view model.hybrid)
    , hr [] []
    , h2 []
      [ text "OnSubmit"
      , button [ class "btn btn-primary pull-right", onClick Reset ] [ text "Reset" ]
      ]
    , map UpdateOnSubmit (OnSubmit.view model.onSubmit)
    , hr [] []
    , h2 []
      [ text "OnSubmit Hybrid"
      , button [ class "btn btn-primary pull-right", onClick Reset ] [ text "Reset" ]
      ]
    , map UpdateOnSubmitHybrid (OnSubmitHybrid.view model.onSubmitHybrid)
    ]
