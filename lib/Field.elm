module Field exposing (..)


import Html exposing (Html, Attribute, text, div, button)
import Html.App as App
import Html.Attributes as A exposing (..)
import Html.Events exposing (onInput, onBlur, onClick)
import List
import String
import Validation exposing (Validation)


-- Model

type alias Model =
  { name : String
  , help : String
  , touched : Bool
  , focused : Bool
  , validate : (String -> String -> Validation String String)
  , value : String
  }

-- init : String -> String -> Model
-- init name help = field name help False False ""

init : String -> String -> (String -> String -> Validation String String) -> String -> Model
init name help validate value =
  Model name help False False validate value

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

isOk : Model -> Bool
isOk model =
  Validation.isOk (model.validate model.name model.value)

update : Msg -> Model -> Model
update msg model =
  case msg of
    Change a ->
      { model
      | value = a
      , touched = True
      }
    Blur ->
      { model
      | focused = (String.length model.value) > 0
      }
    Validate ->
      { model
      | focused = True
      , touched = True
      }
    Noop -> model
