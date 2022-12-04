include("base.jl")

open(Personal.to_path(ARGS[1]), "r") do input
  pairs = sum(readlines(input)) do token
    sections = parse.(Int, split(token, [',', '-']))
    [(sections[1] - sections[3]) * (sections[2] - sections[4]) ≤ 0,
     !(sections[2] < sections[3] || sections[4] < sections[1])]
  end
  println(pairs)
end

