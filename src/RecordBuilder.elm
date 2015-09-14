module RecordBuilder (Error (..), build) where

import Dict exposing (Dict)
import Result exposing (andThen)

import Native.RecordBuilder

build : a -> Dict String b -> Result Error a
build proto dict =
  let
    check err underTest =
      if nativeCheck err proto underTest
      then Ok underTest
      else Err err
           
  in
    if Dict.isEmpty dict
    then Err MissingFields
    else
      Dict.toList dict
        |> Native.RecordBuilder.translate
        |> \q -> Ok q
           `andThen` \r -> check MissingFields r
           `andThen` \s -> check ExtraFields s
           `andThen` \t -> check TypeMismatch t


nativeCheck : Error -> (a -> a -> Bool)
nativeCheck err =
  case err of
    MissingFields ->
      Native.RecordBuilder.checkMissingFields
    ExtraFields ->
      Native.RecordBuilder.checkExtraFields
    TypeMismatch ->
      Native.RecordBuilder.checkTypes

            
type Error = MissingFields | ExtraFields | TypeMismatch
