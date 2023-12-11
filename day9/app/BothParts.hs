module BothParts where

import System.IO
import Data.List
import Data.List.Split

parseInput :: String -> [[Int]]
parseInput contents =
    let splitLines = map (splitOn " ") (splitOn "\n" contents)
    in map (map read) splitLines

deltas :: [Int] -> [Int]
deltas (x : y : xs) = (y - x) : deltas (y : xs)
deltas _ = []

predictNext :: [Int] -> Int
predictNext history
    | all ((==) 0) history = 0
    | otherwise = last history + (predictNext $ deltas history)

main :: IO ()
main = do
    handle <- openFile "input.txt" ReadMode  
    contents <- hGetContents handle  
    let parsedLines = parseInput contents
    -- part 1
    print $ sum $ map predictNext parsedLines
    -- part 2
    print $ sum $ map (predictNext . reverse) parsedLines
