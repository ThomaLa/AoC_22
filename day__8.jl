include("base.jl")

function part1!(visible, max, tree, i, j)
  if tree > max[1]
    max[1] = tree
    push!(visible, (i, j))
  end
end

function part2!(seen, scores, tree, i, j)
  scores[i][j] *= seen[tree]
  seen[1:tree] .= 1
  seen[tree+1:end] .+= 1
end

open(Personal.to_path(ARGS[1]), "r") do input
  trees = [[parse(Int, c) + 1 for c in line] for line in readlines(input)]
  visible = Set()
  scores = [[1 for _ in line] for line in trees]
  
  for (i, line) in enumerate(trees)
    seen = [0 for _ in 1:10]
    max = line[1:1]
    push!(visible, (i, 1))
    for (j, tree) in enumerate(line)
      part1!(visible, max, tree, i, j)
      part2!(seen, scores, tree, i, j)
    end
    seen = [0 for _ in 1:10]
    max = line[end:end]
    push!(visible, (i, length(line)))
    for j in length(line):-1:1
      tree = line[j]
      part1!(visible, max, tree, i, j)
      part2!(seen, scores, tree, i, j)
    end
  end
  for (j, first) in enumerate(trees[1])
    push!(visible, (1, j))
    max = [first]
    seen = [0 for _ in 1:10]
    for (i, line) in enumerate(trees)
      tree = line[j]
      part1!(visible, max, tree, i, j)
      part2!(seen, scores, tree, i, j)
    end
  end
  for (j, last) in enumerate(trees[end])
    push!(visible, (length(trees), j))
    max = [last]
    seen = [0 for _ in 1:10]
    for i in length(trees):-1:1
      tree = trees[i][j]
      part1!(visible, max, tree, i, j)
      part2!(seen, scores, tree, i, j)
    end
  end

  println("Part 1: ", length(visible))
  println("Part 2: ", max(max.(scores...)...))
end
