module Field.DateFocusInline exposing (..)

import Html exposing (Attribute, Html, text, div, input)
import Html.Attributes as A exposing (..)
import Html.Events exposing (onInput, onBlur, onFocus)
import String
import Char
import Maybe
import Focus

-- Model

type alias Model =
  { value : String
  , focus : Bool
  , id : Maybe String
  }

type alias Date = (String, String, String)

init : Maybe String -> Model
init id = Model "//" False id

type Msg
  = Focus Bool
  | UpdateDay Date String
  | UpdateMonth Date String
  | UpdateYear Date String

prefixId : String -> String -> String
prefixId field base =
  base ++ "-" ++ field

idToFocus : String -> String -> Cmd msg
idToFocus field base =
  Focus.focus (prefixId field base)

setFocus : String -> String -> Maybe String -> Cmd msg
setFocus value field base =
  if (String.length value) == 2 then
    Maybe.map (idToFocus field) base
      |> Maybe.withDefault Cmd.none
  else
    Cmd.none

idToAttribute : String -> String -> List (Attribute msg)
idToAttribute field base =
  [A.id (prefixId field base)]

idAttribute : String -> Maybe String -> List (Attribute msg)
idAttribute field base =
  Maybe.map (idToAttribute field) base
    |> Maybe.withDefault []

toList : a -> List a
toList value = [value]

toId : Maybe String -> List (Attribute msg)
toId id =
  Maybe.map (A.id >> toList) id
    |> Maybe.withDefault []

update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  let
    { id } = model
  in
    case msg of
      Focus a ->
        ( { model | focus = a }
        , Cmd.none
        )
      UpdateDay (_, m, y) d ->
        ( { model | value = applyMask (d, m, y) }
        , setFocus d "month" id
        )
      UpdateMonth (d, _, y) m ->
        ( { model | value = applyMask (d, m, y) }
        , setFocus m "year" id
        )
      UpdateYear (d, m, _) y ->
        ( { model | value = applyMask (d, m, y) }
        , Cmd.none
        )

removeMask : String -> Date
removeMask a =
  case (String.split "/" a) of
    [] -> ("", "", "")
    d :: [] -> (d, "", "")
    d :: m :: [] -> (d, m, "")
    d :: m :: y :: _ -> (d, m, y)

applyMask : Date -> String
applyMask (d, m, y) = d ++ "/" ++ m ++ "/" ++ y

-- View

view : Model -> Html Msg
view { id, value, focus } =
  let
    date = removeMask value
    (day, month, year) = date
    hasFocus =
      if focus then
        " has-focus"
      else
        ""
  in
    div
      (class ("form-control-date-container" ++ hasFocus)
        :: (toId id))
      [ input
          ( List.append
              (idAttribute "day" id)
              [ class "form-control-date"
              , style [ ("width", "2em") ]
              , type' "number"
              , onInput (UpdateDay date)
              , onFocus (Focus True)
              , onBlur (Focus False)
              , A.value day
              ]
          )
          []
      , text "/"
      , input
          ( List.append
              (idAttribute "month" id)
              [ class "form-control-date"
              , style [ ("width", "2em") ]
              , type' "number"
              , onInput (UpdateMonth date)
              , onFocus (Focus True)
              , onBlur (Focus False)
              , A.value month
              ]
          )
          []
      , text "/"
      , input
          ( List.append
              (idAttribute "year" id)
              [ class "form-control-date"
              , style [ ("width", "3em") ]
              , type' "number"
              , onInput (UpdateYear date)
              , onFocus (Focus True)
              , onBlur (Focus False)
              , A.value year
              ]
          )
          []
      ]
