include("base.jl")

function follow(head, tail)
  diff = head - tail
  abs(diff[1] * diff[2]) == 2 ? min.(max.(diff, -1), 1) : diff .÷ 2
end

open(Personal.to_path(ARGS[1]), "r") do input
  size = parse(Int, ARGS[2])
  positions = [[0, 0] for _ in 1:size]
  visited = Set()
  directions = Dict('U'=>[0,1],'D'=>[0,-1],'R'=>[1,0],'L'=>[-1,0])

  function move!(knot, direction)
    positions[knot] += direction
    if knot < size
      move!(knot+1, follow(positions[knot:knot+1]...))
    else
      push!(visited, positions[knot])
    end
  end

  for line in readlines(input), _ in 1:parse(Int, line[3:end]) 
    move!(1, directions[line[1]])
  end
  println(length(push!(visited, [0,0])))
end
