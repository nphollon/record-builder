A library for converting dictionaries to records. At different
points in the life-cycle of your program, you may want the data-manipulation
power of a dictionary or the type-safety of a record.

CAUTION: The Elm compiler will not warn you if the values of your record have a
different type than the values of the dictionary. Some type-checking is done at
runtime, but runtime errors are still possible.

    type alias Parents = { father : String, mother : String }
    prototype = { father = "Ward", mother = "June" }

    Dict.fromList [("father", "Hermann"), ("mother", "Lily")] |> build prototype
    -- Just { father = "Hermann", mother = "Lily" }

    Dict.fromList [("father", "Gomez"), ("mother", "Morticia"), ("cousin", "It")] |> build prototype
    -- Nothing

    Dict.fromList [("father", "Andy")] |> build prototype
    -- Nothing
