module AStarTests exposing (tests)

import AStar exposing (..)
import Array
import Check exposing (..)
import Check.Producer exposing (..)
import Check.Test exposing (evidenceToTest)
import ElmTest exposing (..)
import Set exposing (Set)


tests : Test
tests =
    ElmTest.suite "AStar"
        [ findPathTests
        , evidenceToTest
            << quickCheck
            <| Check.suite "all claims"
                [ findPathClaims
                , horizontalCostClaims
                ]
        ]


findPathTests : Test
findPathTests =
    ElmTest.suite "findPath"
        [ defaultTest
            <| assertEqual (findPath horizontalCost movesFrom ( 0, 0 ) ( 2, 0 ))
                (Just (Array.fromList [ ( 1, 0 ), ( 2, 0 ) ]))
        ]


findPathClaims : Claim
findPathClaims =
    Check.suite "findPath"
        [ claim "If all moves are available, a path is always found."
            `true` (\( start, end ) ->
                        findPath horizontalCost movesFrom start end
                            /= Nothing
                   )
            `for` filter (\( start, end ) -> horizontalCost start end <= 25.0)
                    (tuple ( position, position ))
        ]


horizontalCostClaims : Claim
horizontalCostClaims =
    Check.suite "horizontalCost"
        [ claim "Cost is always non-negative."
            `true` (\( p1, p2 ) -> horizontalCost p1 p2 >= 0.0)
            `for` (tuple ( position, position ))
        ]



------------------------------------------------------------


position : Producer Position
position =
    tuple ( int, int )


movesFrom : Position -> Set Position
movesFrom ( x, y ) =
    Set.fromList
        [ ( x - 1, y )
        , ( x + 1, y )
        , ( x, y - 1 )
        , ( x, y + 1 )
        , ( x - 1, y + 1 )
        , ( x - 1, y - 1 )
        , ( x + 1, y - 1 )
        , ( x + 1, y + 1 )
        ]