module RecordBuilder (build) where

{-| A library for converting dictionaries to records. At different
points in the life-cycle of your program, you may want the data-manipulation
power of a dictionary or the type-safety of a record.

CAUTION: The Elm compiler will not warn you if the values of your record have a
different type than the values of the dictionary. Some type-checking is done at
runtime, but runtime errors are still possible.
-}

import Dict exposing (Dict)

import Native.RecordBuilder


{-| Try to create a record with the same keys & values as the given dictionary.
If the dictionary does not have exactly the same fields as the given record,
return `Nothing`.

    type alias Parents = { father : String, mother : String }
    prototype = { father = "Ward", mother = "June" }

    Dict.fromList [("father", "Hermann"), ("mother", "Lily")] |> build prototype
    -- Just { father = "Hermann", mother = "Lily" }

    Dict.fromList [("father", "Gomez"), ("mother", "Morticia"), ("cousin", "It")] |> build prototype
    -- Nothing

    Dict.fromList [("father", "Andy")] |> build prototype
    -- Nothing
-}
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
