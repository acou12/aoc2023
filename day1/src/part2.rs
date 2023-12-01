use std::io;

/**
 * Determines if `substring` lies in `s` starting at `index`.
 */
fn substring_starting_at_index(s: &str, substring: &str, start_index: usize) -> bool {
    start_index + substring.len() - 1 < s.len() && {
        for (c1, c2) in substring.chars().zip(s[start_index..].chars()) {
            if c1 != c2 {
                return false;
            }
        }
        true
    }
}

fn main() {
    let stdin = io::stdin();

    let mut line = String::new();

    let mut sum = 0;

    loop {
        line.clear();
        stdin.read_line(&mut line).expect("Failed to read line");

        let line = line.trim();

        if line == "done" {
            break;
        }

        let mut s = String::new();

        let digits = vec![
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "one", "two", "three", "four",
            "five", "six", "seven", "eight", "nine",
        ];

        fn string_from_digits_index(i: usize) -> String {
            (if i < 10 { i } else { i - 10 + 1 }).to_string()
        }

        'outer: for start_index in 0..line.len() {
            for (i, word) in digits.iter().enumerate() {
                if substring_starting_at_index(line, word, start_index) {
                    s.push_str(&string_from_digits_index(i)[..]);
                    break 'outer;
                }
            }
        }

        'outer: for rev_start_index in 0..line.len() {
            let start_index = line.len() - rev_start_index - 1;
            for (i, word) in digits.iter().enumerate() {
                if substring_starting_at_index(line, word, start_index) {
                    s.push_str(&string_from_digits_index(i)[..]);
                    break 'outer;
                }
            }
        }

        let n = s.parse::<u32>().unwrap();

        sum += n;
    }

    println!("{sum}");
}
