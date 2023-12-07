module Part2 where

import System.IO  
import Data.List
import Data.List.Split
import Data.Maybe
import Data.Function
import Debug.Trace

data Range = Range {destRangeStart   :: Int,
                   sourceRangeStart  :: Int,
                   rangeLength       :: Int} deriving (Show)

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

getMatchingRange :: [Range] -> Int -> Maybe Range
getMatchingRange ranges x = find (\r -> rangeMatches r x) ranges

getNext :: [Range] -> Int -> Int
getNext ranges x =
   case getMatchingRange ranges x of
        Just range -> (destRangeStart range) + (x - (sourceRangeStart range)) 
        Nothing -> x

nextMinimumLocal :: [Range] -> Int -> Maybe Int
nextMinimumLocal ranges x =
    let matchingRange = getMatchingRange ranges x
    in case matchingRange of
        Just (Range _ sourceRangeStart rangeLength) -> Just $ sourceRangeStart + rangeLength
        Nothing ->
            let above = filter (\r -> x < sourceRangeStart r) ranges
            in if length above > 0 then
                Just $ sourceRangeStart (minimumBy (compare `on` sourceRangeStart) above)
            else
                Nothing

traversalRanges :: [[Range]] -> Int -> [(Int, Maybe Int)]
traversalRanges [] x = []
traversalRanges (r : rs) x = (x, nextMinimumLocal r x) : (traversalRanges rs (getNext r x))

finalSeedLocation :: [[Range]] -> Int -> Int
finalSeedLocation [] x = x
finalSeedLocation (r : rs) x = finalSeedLocation rs (getNext r x)

lm :: [[Range]] -> Int -> Maybe Int
lm sections x =
    let arr = traversalRanges sections x >>= (\t ->
            let (x, my) = t
            in case my of
                Just y -> [y - x]
                Nothing -> []
         )
    in case arr of
        [] -> Nothing
        arr -> Just $ minimum arr

lms :: [[Range]] -> Int -> Int -> [Int]
lms sections x upToExcl =
    if x < upToExcl then
        case lm sections x of
            Just offset -> x : lms sections (x + offset) upToExcl
            Nothing -> [x]
    else []

answer :: [[Range]] -> Int -> Int -> Int
answer sections from offset =
    minimum $ map (finalSeedLocation sections) $ lms sections from (from + offset)

groupSize :: forall a. Int -> [a] -> [[a]]
groupSize _ [] = []
groupSize n xs = g : groupSize n gs
            where (g, gs) = splitAt n xs

main :: IO ()
main = do  
    handle <- openFile "input.txt" ReadMode  
    contents <- hGetContents handle  
    let (seeds, sections) = parseAll contents
    -- print $ map (finalSeedLocation sections) [105786393, 105786394, 105786395]
    -- print $ minimum $ map (finalSeedLocation sections) $ lms sections 1 50
    print $ minimum $ map (\(x : y : []) -> answer sections x y) $ groupSize 2 seeds