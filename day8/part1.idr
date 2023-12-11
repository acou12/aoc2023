module Main

data Direction : Type where
    TurnLeft : Direction
    TurnRight : Direction

parseDirections' : List Char -> List Direction
parseDirections' [] = []
parseDirections' (c :: cs) =
    case c of
        'L' => TurnLeft :: parseDirections' cs
        'R' => TurnRight :: parseDirections' cs
        _ => []

parseDirections : String -> List Direction
parseDirections s = parseDirections' (unpack s)

directions : List Direction
directions = parseDirections "LRLRLLRLRLRRLRLRLRRLRLRLLRRLRRLRLRLRLLRRRLRRRLLRRLRLRLRRRLRRLRRRLRLRLRRLRLLRLRLRRLRRRLRLRRLRRRLLRLRLRRRLRRRLRLRRRLRLRRRLLRRLLLRRRLLRRRLRRRLRRRLRLRLRLLRLRRLRLRLLLRRLRRLRRLRLRRLRRLLRRLRLRRRLRLRLLRRRLRRRLRRRLLLRRRLRLRLRRLRRRLRRRLRLRRRLRRLRRRLRLRRLLRRRLRRRLLLRRLRLRLRRLRRRLRRLRRLRLRRRR"

simulate : String -> List (String, String, String) -> List Direction -> List Direction -> Integer
simulate location inputMap dir [] = simulate location inputMap dir dir
simulate "ZZZ" _ _ _ = 0
simulate location inputMap dir (d :: ds) =
    let matching = Prelude.List.head' $ filter (\(a, _, _) => a == location) inputMap
        (a, left, right) = fromMaybe ("", "", "") matching
        nextLocation = case d of
            TurnLeft => left
            TurnRight => right
    in 1 + simulate nextLocation inputMap dir ds

main : IO ()
main = do
    file <- readFile "input.txt"
    case file of
        Left _ => pure ()
        Right input =>
            let inputSplit = filter (/= "") $ lines input
                inputMap = map (\s => (substr 0 3 s, substr 7 3 s, substr 12 3 s)) inputSplit
            in print $ simulate "AAA" inputMap directions directions
