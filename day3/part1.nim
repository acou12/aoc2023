import std/parseutils
import std/strutils
import std/sets

type Number = object
    value: int
    location: (int, int)

type Symbol = object
    location: int

type ParseInputResult = object
    numbers: seq[Number]
    symbols: seq[Symbol]

type ParseNumberResult = object
    result: bool
    value: int
    location: (int, int)
    new_index: int

proc is_numeric_char(c: char): bool = '0' <= c and c <= '9'

proc parse_number(s: string, start_index: int): ParseNumberResult =
    if is_numeric_char(s[start_index]):
        var end_index = start_index + 1
        while end_index < s.len() and is_numeric_char(s[end_index]):
            end_index += 1
        var value: int
        discard parse_int(s[start_index..<end_index], value)
        ParseNumberResult(result: true, value: value, location: (start_index, end_index), new_index: end_index)
    else:
        ParseNumberResult(result: false)

type ParseSymbolResult = object
    result: bool
    location: int
    new_index: int

proc parse_symbol(s: string, start_index: int): ParseSymbolResult =
    if s[start_index] != '.' and s[start_index] != '\n':
        ParseSymbolResult(result: true, location: start_index, new_index: start_index + 1)
    else:
        ParseSymbolResult(result: false) 

proc parse_input(s: string, pr: var ParseInputResult) =
    var index = 0
    while index < s.len():
        let parse_number_result = parse_number(s, index)
        if parse_number_result.result:
            index = parse_number_result.new_index
            pr.numbers.add(Number(value: parse_number_result.value, location: parse_number_result.location))
        else:
            let parse_symbol_result = parse_symbol(s, index)
            if parse_symbol_result.result:
                index = parse_symbol_result.new_index
                pr.symbols.add(Symbol(location: parse_symbol_result.location))
            else:
                index += 1

proc is_part_number(n: Number, pr: ParseInputResult, line_length: int): bool =
    let row = n.location[0] div line_length
    let col_start = n.location[0] mod line_length
    let col_end = n.location[1] mod line_length
    for s in pr.symbols:
        let s_row = s.location div line_length
        let s_col = s.location mod line_length
        if abs(s_row - row) <= 1 and col_start - 1 <= s_col and s_col <= col_end:
            return true
    false

proc main =
    let input_text = readFile("input.txt")
    var pr: ParseInputResult
    let line_length = input_text.find('\n') + 1
    parse_input(input_text, pr)
    var part_numbers: HashSet[Number]
    part_numbers.init()
    for n in pr.numbers:
        if is_part_number(n, pr, line_length):
            part_numbers.incl(n)
    var sum = 0
    while part_numbers.len() > 0:
        sum += part_numbers.pop().value
    echo sum

main()