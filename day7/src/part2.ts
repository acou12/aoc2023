const charFrequency = (s: string) => {
  const map: Record<string, number> = {};
  for (const c of s) {
    if (map[c] !== undefined) {
      map[c]++;
    } else {
      map[c] = 1;
    }
  }
  return map;
};

const equals = <T>(ts1: T[], ts2: T[]) => {
  if (ts1.length !== ts2.length) {
    return false;
  } else {
    for (let i = 0; i < ts1.length; i++) {
      if (ts1[i] !== ts2[i]) return false;
    }
    return true;
  }
};

const typeScore = (freq: Record<string, number>): number => {
  const values = Object.keys(freq).map((k) => freq[k]);
  values.sort((x, y) => x - y);
  if (equals(values, [5])) {
    return 7;
  } else if (equals(values, [1, 4])) {
    return 6;
  } else if (equals(values, [2, 3])) {
    return 5;
  } else if (equals(values, [1, 1, 3])) {
    return 4;
  } else if (equals(values, [1, 2, 2])) {
    return 3;
  } else if (equals(values, [1, 1, 1, 2])) {
    return 2;
  } else if (equals(values, [1, 1, 1, 1, 1])) {
    return 1;
  }
  throw new Error("impossible.");
};

const bestScore = (s: string) => {
  let all: string[] = [""];
  for (let i = 0; i < s.length; i++) {
    const c = s[i];
    if (c === "J") {
      all = all.flatMap((s) => [..."23456789TQKA"].map((c) => s + c));
    } else {
      all = all.map((s) => s + c);
    }
  }
  return all
    .map((x) => typeScore(charFrequency(x)))
    .reduce((acc, x) => (x > acc ? x : acc));
};

const fix = (s: string) =>
  s
    .replace(/A/g, "E")
    .replace(/T/g, "A")
    .replace(/J/g, "@")
    .replace(/Q/g, "C")
    .replace(/K/g, "D");

export const part2 = (input: string) => {
  const bets = input
    .split("\n")
    .map((line) => line.split(" "))
    .map(([l, r]) => [l, parseInt(r)] as [string, number]);

  bets.sort(([x, _r1], [y, _r2]) => {
    const ts = -(bestScore(x) - bestScore(y));
    if (ts === 0) {
      return -fix(x).localeCompare(fix(y));
    } else {
      return ts;
    }
  });

  console.log(
    bets.map((t, i) => t[1] * (bets.length - i)).reduce((acc, x) => acc + x)
  );
};
