module RecordBuilder (build) where

import Dict exposing (Dict)

import Native.RecordBuilder


build : a -> Dict String b -> Maybe a
build proto dict =
  if Dict.isEmpty dict
  then Nothing
  else
    Dict.toList dict
      |> Native.RecordBuilder.translate
      |> checkFields proto


checkFields : a -> a -> Maybe a
checkFields proto specimen =
  if Native.RecordBuilder.checkFields proto specimen
  then Just specimen
  else Nothing
