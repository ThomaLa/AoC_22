to_path(arg) = "/google/src/cloud/tlapotre/julia/google3/experimental/users/tlapotre/aoc_22/$arg.txt"

open(to_path(ARGS[1]), "r") do input
  biggest = 0
  second = 0
  third = 0
  current = 0
  for token in readlines(input)
    if isempty(token)
      if current > biggest
        third = second
        second = biggest
        biggest = current
      elseif current > second
        third = second
        second = current
      elseif current > third
        third = current
      end
      current = 0
    else
      current += parse(Int, token)
    end
  end
  println("1: $biggest, 2: $(biggest+second+third)")
end
