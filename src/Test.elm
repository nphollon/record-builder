module Test where

import Graphics.Element
import Text
import Dict exposing (Dict)

import ElmTest.Test exposing (Test, test, suite)
import ElmTest.Assertion exposing (assertEqual)
import ElmTest.Runner.String exposing (runDisplay)

import RecordBuilder exposing (build)


main = 
  runDisplay tests
    |> Text.fromString
    |> Graphics.Element.leftAligned


tests : Test
tests = suite "RecordBuilder"
        [ testBuild "Empty dict"
          { expected = Nothing
          , proto = { a = "Hello" }
          , dict = Dict.empty
          }
          
        , testBuild "Matching one string field"
          { expected = Just { a = "Goodbye" }
          , proto = { a = "Hello" }
          , dict = Dict.singleton "a" "Goodbye"
          }

        , testBuild "Matching two string fields"
          { expected = Just { b = "Truth", c = "Beauty" }
          , proto = { b = "Top", c = "Bottom" }
          , dict = Dict.fromList [("b","Truth"), ("c","Beauty")]
          }

        , testBuild "Matching two integer fields"
          { expected = Just { up = 7, down = -10 }
          , proto = { down = 0, up = 0 }
          , dict = Dict.fromList [("up",7), ("down",-10)]
          }

        , testBuild "Dict is missing a field"
          { expected = Nothing
          , proto = { alpha = 1, beta = 2 }
          , dict = Dict.fromList [("beta", 4)]
          }

        , testBuild "Dict has too many fields"
          { expected = Nothing
          , proto = { gamma = 3, delta = 4 }
          , dict = Dict.fromList [("gamma",3),("delta",4),("epsilon",0)]
          }

        , testBuild "Field types do not match"
          { expected = Nothing
          , proto = { zeta = "baloney" }
          , dict = Dict.singleton "zeta" 1
          }
        ]


testBuild : String -> TestData a b -> Test
testBuild name data =
  build data.proto data.dict
    |> assertEqual data.expected
    |> test name
       

type alias TestData a b =
  { expected : Maybe a
  , proto : a
  , dict : Dict String b
  }
