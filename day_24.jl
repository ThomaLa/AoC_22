include("base.jl")

function move(blizzard, limits)
  directions = Dict(zip("^v><", [[0, -1], [0, 1], [1, 0], [-1, 0]]))
  x, y, c = blizzard
  put_within(z, max_z) = z == 0 ? max_z : z > max_z ? 1 : z
  nx, ny = put_within.([x, y] .+ directions[c], limits)
  nx, ny, c
end

function main()
  blizzards = Vector{Tuple{Int, Int, Char}}()
  width = 0, 0
  open(Personal.to_path(ARGS[1])) do input
    for (y, line) in enumerate(readlines(input)), (x, c) in enumerate(line)
      width = x-2, y-2
      if c in "^>v<"
        push!(blizzards, (x-1,  y-1, c))
      end
    end
  end
  println("Grid of size $width")
  empty_spaces = Vector{Set{Tuple{Int, Int}}}()
  full_grid = Set((x, y) for x in 1:width[1], y in 1:width[2])
  for _ in 1:lcm(width...)
    push!(empty_spaces, setdiff(full_grid, (blizzard[1:2] for blizzard in blizzards)))
    push!(empty_spaces[end], (1, 0))
    blizzards = [move(blizzard, width) for blizzard in blizzards]
  end

  function traverse(start, goal, time)
    visited = Set{Tuple{Tuple{Int, Int}, Int}}()
    positions = Set{Tuple{Int, Int}}([start])
    for (step, possible) in enumerate(Iterators.cycle(empty_spaces))
      if step < time
        continue
      elseif isempty(positions)
        println("No positions left to explore!")
        break
      end
      pattern = step % lcm(width...)
      next_positions = Set{Tuple{Int, Int}}()
      for position in positions, direction in [(0, 0), (0, -1), (0, 1), (1, 0), (-1, 0)]
        new_position = position .+ direction
        if !(new_position in possible) && new_position != start
          continue
        elseif !((new_position, pattern) in visited)
          push!(next_positions, new_position)
          push!(visited, (new_position, pattern))
          if all(new_position .== goal)
            println("Reached the end in $step steps!")
            return step
          end
        end
      end
      positions = next_positions
    end 
  end

  time = traverse((1, 0), width, 1)
  time = traverse(width .+ (1, 0), (1, 1), time + 1)
  time = traverse((1, 0), width, time + 1)
end

main()
