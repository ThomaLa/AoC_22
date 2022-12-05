include("base.jl")

function move!(stacks, (by, from, to), reversed)
  moved = stacks[from][end-by+1:end]
  append!(stacks[to], reversed ? reverse(moved) : moved)
  stacks[from] = stacks[from][1:end-by]
end

open(Personal.to_path(ARGS[1]), "r") do input
  raw_stacks = Vector{String}()
  num_stacks = 0
  moves = []
  for token in readlines(input)
    if isempty(token)
      continue
    elseif startswith(token, "move")
      splits = parse.(Int, split(token)[2:2:6])
      push!(moves, splits)
    elseif startswith(strip(token), "[")
      push!(raw_stacks, token)
    else
      num_stacks = (length ∘ split)(token)
    end
  end
  
  old_stacks = [Vector{Char}() for _ in 1:num_stacks]
  for token in reverse(raw_stacks)
    for stack in 0:num_stacks-1
      item = token[stack * 4 + 2]
      if item != ' '
        push!(old_stacks[stack + 1], item)
      end
    end
  end
  new_stacks = deepcopy(old_stacks)

  for move in moves
    move!(old_stacks, move, true)
    move!(new_stacks, move, false)
  end

  map.(last, [old_stacks, new_stacks]) .|> println ∘ join
end

