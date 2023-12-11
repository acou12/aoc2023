module Part2 where

import System.IO
import Data.List
import Data.List.Split
import Debug.Trace

data GalaxyLocation = GalaxyLocation { x :: Int, y :: Int }
      deriving (Show)

indexed xs = zip [0..(length xs)] xs

indexesOfChar :: Char -> String -> [Int]
indexesOfChar char string = foldr (\(i, headChar) acc -> if headChar == char then i : acc else acc) [] $ indexed string 

parseInput :: String -> [GalaxyLocation]
parseInput contents = do
    let lines = splitOn "\n" contents
    let lineGalaxies = map (indexesOfChar '#') lines
    (y, xs) <- indexed lineGalaxies
    x <- xs
    pure $ GalaxyLocation x y

deltas :: [Int] -> [Int]
deltas (x1 : x2 : xs) = (x2 - x1) : deltas (x2 : xs)
deltas _ = []

emptySpaces :: [Int] -> [Int]
emptySpaces = map (\d -> if d > 0 then (d - 1) * (1000000 - 1) else 0) . deltas
--                                               ^^^^^^^^^^^^^
--                                               the only difference between this and part 1

updates :: [Int] -> [Int]
updates = scanl (+) 0 . emptySpaces

expand :: [Int] -> [Int]
expand xs = zipWith (+) (updates xs) xs

expandAxis :: 
    (GalaxyLocation -> Int)
    -> (GalaxyLocation -> Int -> GalaxyLocation)
    -> [GalaxyLocation]
    -> [GalaxyLocation]
expandAxis get update galaxies =
    let sorted = sortOn get galaxies
        new = expand $ map get sorted
    in zipWith (\galaxy n -> update galaxy n) sorted new

updateX :: GalaxyLocation -> Int -> GalaxyLocation
updateX (GalaxyLocation oldX y) x = GalaxyLocation x y

updateY :: GalaxyLocation -> Int -> GalaxyLocation
updateY (GalaxyLocation x oldY) y = GalaxyLocation x y

expanded :: [GalaxyLocation] -> [GalaxyLocation]
expanded = id
    . expandAxis x updateX
    . expandAxis y updateY

distances :: [GalaxyLocation] -> Int
distances galaxies = sum $ do
    first <- galaxies
    second <- galaxies
    pure $ abs (x first - x second) + abs (y first - y second)

main :: IO ()
main = do
    handle <- openFile "input.txt" ReadMode  
    contents <- hGetContents handle  
    let galaxies = parseInput contents
    let expandedGalaxies = expanded galaxies
    print $ galaxies
    print $ expandedGalaxies
    print $ div (distances expandedGalaxies) 2