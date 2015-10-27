module RecordBuilder (build) where

{-| A library for converting dictionaries to records. At different
points in the life-cycle of your program, you may want the data-manipulation
power of a dictionary or the type-safety of a record.

CAUTION: The Elm compiler will not warn you if the values of your record have a
different type than the values of the dictionary. Some type-checking is done at
runtime, but runtime errors are still possible.

@docs build
-}

import Dict exposing (Dict)

import Json.Encode as Encode exposing (Value)
import Json.Decode as Decode exposing (Decoder, andThen, map, (:=))


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


encodeDict : (a -> Value) -> Dict String a -> Value
encodeDict f =
  Dict.map (always f) >> Dict.toList >> Encode.object


decode : Decoder f -> Decoder { a : f, b : f }
decode f =
  let
    init a b = { a = a, b = b }
  in
    Decode.succeed init
            `andMap` ("a" := f)
            `andMap` ("b" := f)

                   
buildData : Dict String String -> Result String { a : String, b : String }
buildData =
  recode (encodeDict Encode.string) (decode Decode.string)

              
andMap : Decoder (a -> b) -> Decoder a -> Decoder b
andMap partial next =
  partial `andThen` (map `flip` next)

                      
recode : (b -> Value) -> Decoder a -> b -> Result String a
recode encode decoder =
    encode >> Decode.decodeValue decoder

       
