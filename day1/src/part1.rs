use std::io;

fn main() {
    let stdin = io::stdin();

    let mut line = String::new();

    let mut sum = 0;

    loop {
        line.clear();
        stdin.read_line(&mut line).expect("Failed to read line");
        if line.trim() == "done" {
            break;
        }
        let mut first: char = '0';
        let mut second: char = '0';
        for c in line.chars() {
            if '0' <= c && c <= '9' {
                first = c;
                break;
            }
        }
        for c in line.chars().rev() {
            if '0' <= c && c <= '9' {
                second = c;
                break;
            }
        }
        let mut s = String::new();
        s.push(first);
        s.push(second);

        let n: u32 = s.parse().unwrap();
        sum += n;
    }

    println!("{sum}");
}
