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
        
        -- Happy paths
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

        -- Dict is the wrong size
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

        -- Malformed prototype
        , testBuild "Prototype is a non-uniform record"
          { expected = Nothing
          , proto = { omicron = False, iota = 0 }
          , dict = Dict.fromList [("omicron", False), ("iota", False)]
          }

        , testBuild "Prototype is a number"
          { expected = Nothing
          , proto = 1
          , dict = Dict.singleton "1" 1
          }

        , testBuild "Prototype is a list"
          { expected = Nothing
          , proto = [ ("a", 0), ("b", 1) ]
          , dict = Dict.fromList [("a", 0), ("b", 1)]
          }

        -- Sneaky dict types
        , testBuild "Field types do not match"
          { expected = Nothing
          , proto = { zeta = "baloney" }
          , dict = Dict.singleton "zeta" 1
          }

        , testBuild "String vs Char"
          { expected = Nothing
          , proto = { theta = 'A' }
          , dict = Dict.singleton "theta" 'A'
          }

        , suite "Documentation"
          [ testBuild "Munster"
            { expected = Just { father = "Hermann", mother = "Lily" }
            , proto = cleaver
            , dict = Dict.fromList [("father", "Hermann"), ("mother", "Lily")]
            }
            
          , testBuild "Addams"
            { expected = Nothing
            , proto = cleaver
            , dict = Dict.fromList [("father", "Gomez"), ("mother", "Morticia"), ("cousin", "It")]
            }

          , testBuild "Taylor"
            { expected = Nothing
            , proto = cleaver
            , dict = Dict.singleton "father" "Andy"
            }
          ]
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

 
cleaver = { father = "Ward", mother = "June" }


