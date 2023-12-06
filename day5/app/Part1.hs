module Part1 where

import System.IO  
import Data.List
import Data.List.Split
import Data.Maybe
import Debug.Trace

data Range = Range {destRangeStart   :: Int,
                   sourceRangeStart :: Int,
                   rangeLength      :: Int} deriving (Show)

parseLine :: String -> Range
parseLine line =
    let [destRangeStart, sourceRangeStart, rangeLength]
         = map read $ splitOn " " line
    in Range destRangeStart sourceRangeStart rangeLength

parseSection :: String -> [Range]
parseSection section =
    let lines = splitOn "\n" section
        lines' = drop 1 lines -- skip the header
    in map parseLine lines'

-- point free 🤯
parseSeeds :: String -> [Int]
parseSeeds = (map read) . (drop 1) . (splitOn " ")

parseAll :: String -> ([Int], [[Range]])
parseAll input =
    let section_strs = splitOn "\n\n" input

        seeds_str : rest_section_strs = section_strs

        seeds = parseSeeds seeds_str
        sections = map parseSection rest_section_strs
    in (seeds, sections)

rangeMatches :: Range -> Int -> Bool
rangeMatches (Range _ sourceRangeStart rangeLength) x =
    (sourceRangeStart <= x) && (x < sourceRangeStart + rangeLength)
 
getNext :: [Range] -> Int -> Int
getNext ranges x =
   let mRange = find (\r -> rangeMatches r x) ranges
   in case mRange of
        Just range -> (destRangeStart range) + (x - (sourceRangeStart range)) 
        Nothing -> x

finalSeedLocation :: [[Range]] -> Int -> Int
finalSeedLocation sections x =
    case sections of
        [] -> x
        r : rs ->
            finalSeedLocation rs (getNext r x)

main :: IO ()
main = do  
    handle <- openFile "input.txt" ReadMode  
    contents <- hGetContents handle  
    let (seeds, sections) = parseAll contents
        locations = map (finalSeedLocation sections) seeds
    print $ minimum locations
