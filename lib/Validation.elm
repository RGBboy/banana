module Validation exposing  (..)

import List
import String

-- Validation

type Validation x a
  = Success a
  | Failure (List x) a

validationValue : Validation x a -> a
validationValue v =
  case v of
    Success a -> a
    Failure _ a -> a

validationErrors : Validation String a -> List String
validationErrors v =
  case v of
    Success a -> []
    Failure x a -> x

hasError : Validation x a -> Bool
hasError v =
  case v of
    Success a -> False
    Failure x a -> True

-- ???
conj : Validation x a -> Validation x a -> Validation x a
conj v1 v2 =
  case v1 of
    Success a1 ->
      case v2 of
        Success a1 -> Success a1
        Failure x2 a2 -> Failure x2 a1
    Failure x1 a1 ->
      case v2 of
        Success a2 -> Failure x1 a1
        Failure x2 a2 -> Failure (List.append x1 x2) a1

isMoreThan : String -> Int -> String -> Validation String String
isMoreThan name num value =
  if (String.length value) > num then
    Success value
  else
    Failure [(name ++ " is too short")] value

isLessThan : String -> Int -> String -> Validation String String
isLessThan name num value =
  if (String.length value) < num then
    Success value
  else
    Failure [(name ++ " is too long")] value

containsNoHyphen : String -> String -> Validation String String
containsNoHyphen name value =
  if not (String.contains "-" value) then
    Success value
  else
    Failure [(name ++ " contains a hyphen")] value

validateName : String -> String -> Validation String String
validateName name value =
  (containsNoHyphen name value)
  |> conj (isMoreThan name 1 value)
  |> conj (isLessThan name 6 value)
