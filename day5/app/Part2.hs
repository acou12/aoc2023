module Part2 where

import System.IO  
import Data.List
import Data.List.Split
import Data.Maybe
import Debug.Trace

data Range = Range {destRangeStart   :: Int,
                   sourceRangeStart  :: Int,
                   rangeLength       :: Int} deriving (Show)

data Piecewise = Piecewise {inclLow  :: Int,
                            exclHigh :: Int,
                            offset   :: Int} deriving (Show)

toPiecewise :: Range -> Piecewise
toPiecewise range =
    Piecewise {inclLow = sourceRangeStart range,
                exclHigh = sourceRangeStart range + rangeLength range,
                offset = destRangeStart range - sourceRangeStart range}

fromPiecewise :: Piecewise -> Range
fromPiecewise piecewise =
    Range {destRangeStart = inclLow piecewise,
           sourceRangeStart = inclLow piecewise + offset piecewise,
           rangeLength = exclHigh piecewise - inclLow piecewise}

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

-- criticalPoints :: [Piecewise] -> [Piecewise] -> [Piecewise]
-- composePiecewise p1 p2 =
--      map (L)

main :: IO ()
main = do  
    handle <- openFile "small-input.txt" ReadMode  
    contents <- hGetContents handle  
    let (seeds, sections) = parseAll contents
    print $ sections
    print $ map (map toPiecewise) sections

[Piecewise {inclLow = 69, exclHigh = 70, offset = -69},
Piecewise {inclLow = 0, exclHigh = 69, offset = 1}],

[Piecewise {inclLow = 56, exclHigh = 93, offset = 4},
Piecewise {inclLow = 93, exclHigh = 97, offset = -37}]]

0..69  + 1
69..70 -69

56..93 + 4
93..97 -37

0..55 +5