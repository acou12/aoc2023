(ns part2)

(defn parse-frequency [string acc-color-freq]
  (let [split (.split string " ")
        n (Integer/parseInt (get split 1))
        color (get split 2)
        pr (get acc-color-freq 0)
        pg (get acc-color-freq 1)
        pb (get acc-color-freq 2)]
    (case color
      "red" [n pg pb]
      "green" [pr n pb]
      [pr pg n])))

(defn parse-frequencies [descriptions]
  (reduce (fn [freq y] (parse-frequency y freq)) [0 0 0] descriptions))

; Parses a game; returns a pair. The first element is the game id and the second 
; is a list of triples containing (red, green, blue) counts.
(defn parse-game [string]
  (let
   [split (.split string ":")
    left (get split 0)
    right (get split 1)
    game-id (Integer/parseInt (get (.split left "Game ") 1))
    draws (vec (.split right ";"))
    split-draws (map (fn [d] (vec (.split d ","))) draws)
    parsed-freqs (map parse-frequencies split-draws)]
    [game-id parsed-freqs]))

(def input (slurp "src/input.txt"))

(def games (vec (map parse-game (vec (.split input "\n")))))

(defn power [game]
  (let
   [min_freq (reduce (fn [acc freq]
                       [(max (get acc 0) (get freq 0))
                        (max (get acc 1) (get freq 1))
                        (max (get acc 2) (get freq 2))]) [0 0 0] (second game))
    power (* (get min_freq 0) (get min_freq 1) (get min_freq 2))]
    power))

(defn run [opts]
  (println (reduce (fn [acc game] (+ acc (power game))) 0 games)))