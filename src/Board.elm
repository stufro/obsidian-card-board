module Board exposing
    ( Board
    , columns
    , init
    )

import BoardConfig exposing (BoardConfig)
import Card exposing (Card)
import DateBoard
import TagBoard
import TaskItem exposing (TaskItem)
import TaskList exposing (TaskList)
import TimeWithZone exposing (TimeWithZone)



-- TYPES


type Board
    = Board BoardConfig TaskList



-- CONSTRUCTION


init : BoardConfig -> TaskList -> Board
init config taskList =
    Board config taskList



-- INFO


columns : TimeWithZone -> Int -> Board -> List ( String, List Card )
columns timeWithZone boardIndex (Board config taskList) =
    case config of
        BoardConfig.DateBoardConfig dateBoardConfig ->
            DateBoard.columns timeWithZone dateBoardConfig taskList
                |> placeCardsInColumns boardIndex

        BoardConfig.TagBoardConfig tagBoardConfig ->
            TagBoard.columns tagBoardConfig taskList
                |> placeCardsInColumns boardIndex



-- PRIVATE


placeCardsInColumns : Int -> List ( String, List TaskItem ) -> List ( String, List Card )
placeCardsInColumns boardIndex columnList =
    let
        cardIdPrefix : Int -> String
        cardIdPrefix columnIndex =
            String.fromInt boardIndex ++ ":" ++ String.fromInt columnIndex

        placeCardsInColumn : Int -> ( String, List TaskItem ) -> ( String, List Card )
        placeCardsInColumn columnIndex ( columnTitle, taskItems ) =
            taskItems
                |> List.map (Card.fromTaskItem <| cardIdPrefix columnIndex)
                |> Tuple.pair columnTitle
    in
    columnList
        |> List.indexedMap placeCardsInColumn
