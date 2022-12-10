include("base.jl")

follow((h, t)) = maximum(abs.(h - t)) > 1 ? sign.(h - t) : [0, 0]

open(Personal.to_path(ARGS[1]), "r") do input
  size = parse(Int, ARGS[2])
  positions = [[0, 0] for _ in 1:size]
  visited = Set()
  directions = Dict('U'=>[0,1],'D'=>[0,-1],'R'=>[1,0],'L'=>[-1,0])
  
  for line in readlines(input), _ in 1:parse(Int, line[3:end])
    positions[1] += directions[line[1]]
    for knot in 2:size
      positions[knot] += follow(positions[knot-1:knot])
    end
    push!(visited, positions[end])
  end
  visited |> length |> println
end

