include("base.jl")

open(Personal.to_path(ARGS[1]), "r") do input
  n = 99
  grid = zeros(Int, n, n)
  for (i, line) in enumerate(eachline(input))
    grid[i, :] = parse.(Int, collect(line))
  end
  visible = zeros(Int, size(grid))
  scores = ones(Int, size(grid))
  directions = ([0, 1], [1, 0], [-1, 0], [0, -1])
  for i in 1:n, j in 1:n, direction in directions
    position = [i, j] + direction
    score = 1
    while checkbounds(Bool, grid, position...) && grid[position...] < grid[i, j]
      score += 1
      pos += direction
    end
    if !checkbounds(Bool, grid, position...)
      visible[i, j] = 1
      score -= 1
    end
    scores[i,j] *= score
  end
  println("Part 1: ", sum(visible))
  println("Part 2: ", maximum(scores[2:end-1, 2:end-1]))
end
