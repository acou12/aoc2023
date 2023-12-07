"use strict";
var __values = (this && this.__values) || function(o) {
    var s = typeof Symbol === "function" && Symbol.iterator, m = s && o[s], i = 0;
    if (m) return m.call(o);
    if (o && typeof o.length === "number") return {
        next: function () {
            if (o && i >= o.length) o = void 0;
            return { value: o && o[i++], done: !o };
        }
    };
    throw new TypeError(s ? "Object is not iterable." : "Symbol.iterator is not defined.");
};
var __read = (this && this.__read) || function (o, n) {
    var m = typeof Symbol === "function" && o[Symbol.iterator];
    if (!m) return o;
    var i = m.call(o), r, ar = [], e;
    try {
        while ((n === void 0 || n-- > 0) && !(r = i.next()).done) ar.push(r.value);
    }
    catch (error) { e = { error: error }; }
    finally {
        try {
            if (r && !r.done && (m = i["return"])) m.call(i);
        }
        finally { if (e) throw e.error; }
    }
    return ar;
};
var __spreadArray = (this && this.__spreadArray) || function (to, from, pack) {
    if (pack || arguments.length === 2) for (var i = 0, l = from.length, ar; i < l; i++) {
        if (ar || !(i in from)) {
            if (!ar) ar = Array.prototype.slice.call(from, 0, i);
            ar[i] = from[i];
        }
    }
    return to.concat(ar || Array.prototype.slice.call(from));
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.part1 = void 0;
var charFrequency = function (s) {
    var e_1, _a;
    var map = {};
    try {
        for (var s_1 = __values(s), s_1_1 = s_1.next(); !s_1_1.done; s_1_1 = s_1.next()) {
            var c = s_1_1.value;
            if (map[c] !== undefined) {
                map[c]++;
            }
            else {
                map[c] = 1;
            }
        }
    }
    catch (e_1_1) { e_1 = { error: e_1_1 }; }
    finally {
        try {
            if (s_1_1 && !s_1_1.done && (_a = s_1.return)) _a.call(s_1);
        }
        finally { if (e_1) throw e_1.error; }
    }
    return map;
};
var equals = function (ts1, ts2) {
    if (ts1.length !== ts2.length) {
        return false;
    }
    else {
        for (var i = 0; i < ts1.length; i++) {
            if (ts1[i] !== ts2[i])
                return false;
        }
        return true;
    }
};
var typeScore = function (freq) {
    var values = Object.keys(freq).map(function (k) { return freq[k]; });
    values.sort(function (x, y) { return x - y; });
    if (equals(values, [5])) {
        return 7;
    }
    else if (equals(values, [1, 4])) {
        return 6;
    }
    else if (equals(values, [2, 3])) {
        return 5;
    }
    else if (equals(values, [1, 1, 3])) {
        return 4;
    }
    else if (equals(values, [1, 2, 2])) {
        return 3;
    }
    else if (equals(values, [1, 1, 1, 2])) {
        return 2;
    }
    else if (equals(values, [1, 1, 1, 1, 1])) {
        return 1;
    }
    throw new Error("impossible.");
};
var bestScore = function (s) {
    var all = [""];
    var _loop_1 = function (i) {
        var c = s[i];
        if (c === "J") {
            all = all.flatMap(function (s) { return __spreadArray([], __read("23456789TQKA"), false).map(function (c) { return s + c; }); });
        }
        else {
            all = all.map(function (s) { return s + c; });
        }
    };
    for (var i = 0; i < s.length; i++) {
        _loop_1(i);
    }
    return all
        .map(function (x) { return typeScore(charFrequency(x)); })
        .reduce(function (acc, x) { return (x > acc ? x : acc); });
};
var fix = function (s) {
    return s
        .replace(/A/g, "E")
        .replace(/T/g, "A")
        .replace(/J/g, "@")
        .replace(/Q/g, "C")
        .replace(/K/g, "D");
};
var part1 = function (input) {
    var bets = input
        .split("\n")
        .map(function (line) { return line.split(" "); })
        .map(function (_a) {
        var _b = __read(_a, 2), l = _b[0], r = _b[1];
        return [l, parseInt(r)];
    });
    bets.sort(function (_a, _b) {
        var _c = __read(_a, 2), x = _c[0], _r1 = _c[1];
        var _d = __read(_b, 2), y = _d[0], _r2 = _d[1];
        var ts = -(bestScore(x) - bestScore(y));
        if (ts === 0) {
            return -fix(x).localeCompare(fix(y));
        }
        else {
            return ts;
        }
    });
    //   console.log(
    //     ["AAAAA", "AA8AA", "23332", "TTT98", "23432", "A23A4", "23456"].map((x) =>
    //       typeScore(charFrequency(x))
    //     )
    //   );
    console.log(bets
        //   .map((x) => x[0])
        //   .map((x) => typeScore(charFrequency(x)))
        .join("\n"));
    console.log(bets.map(function (t, i) { return t[1] * (bets.length - i); }).reduce(function (acc, x) { return acc + x; }));
};
exports.part1 = part1;
