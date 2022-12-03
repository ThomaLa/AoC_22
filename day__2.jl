function outcomes(token)
  other = Int(token[1]) - Int('A')
  you = Int(token[3]) - Int('X') + 4
  diff = (you - other) % 3
  [ 3 *       diff    +          you - 3
    3 * ((you - 1) % 3) + (other + you + 1) % 3 + 1 ]
end

to_path(arg) = "/google/src/cloud/tlapotre/julia/google3/experimental/users/tlapotre/aoc_22/$arg.txt"

open(to_path(ARGS[1]), "r") do input
  el_sum(x, y) = [x[1]+y[1], x[2]+y[2]]
  totals = reduce(el_sum, outcomes.(readlines(input)); init=[0,0])
  println("1: $totals, 2: $(0)")
end
