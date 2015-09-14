module Test where

import Graphics.Element
import Text

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
        [ test "Default" (assertEqual 1 1)
        ]
