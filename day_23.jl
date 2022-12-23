include("base.jl")

function count_spaces(elves)
  min_x, min_y = first(elves)
  max_x, max_y = min_x, min_y
  for (x, y) in elves
    min_x = min(x, min_x)
    max_x = max(x, max_x)
    min_y = min(y, min_y)
    max_y = max(y, max_y)
  end
  (max_x - min_x + 1) * (max_y - min_y + 1) - length(elves)
end

function main()
  elves = Set{Tuple{Int, Int}}()
  open(Personal.to_path(ARGS[1])) do input
    for (y, line) in enumerate(readlines(input)), (x, c) in enumerate(line)
      if c == '#'
        push!(elves, (x, y))
      end
    end
  end

  to_check = Dict('N' => [(0, -1), (-1, -1), (1, -1)],
                  'S' => [(0, 1), (-1, 1), (1, 1)],
                  'W' => [(-1, 0), (-1, -1), (-1, 1)],
                  'E' => [(1, 0), (1, -1), (1, 1)])
  blocked(elf, direction) = any((elf .+ dir) in elves for dir in to_check[direction])
  order = Dict('N' => "NSWE", 'S' => "SWEN", 'W' => "WENS", 'E' => "ENSW")
  function try_move!(elf, direction, moving_elves)
    destination = elf .+ direction
    if destination in keys(moving_elves)
      moving_elves[elf] = elf
      moving_elves[moving_elves[destination]] = moving_elves[destination]
      delete!(moving_elves, destination)
    else
      moving_elves[destination] = elf
    end
  end

  for (step, first_direction) in enumerate(Iterators.cycle("NSWE"))
    moving_elves = Dict{Tuple{Int, Int}, Tuple{Int, Int}}()  # dest => source
    for elf in elves
      if count((elf .+ (x, y)) in elves for x in -1:1, y in -1:1) == 1
        moving_elves[elf] = elf
        continue
      end
      moved = false
      for direction in order[first_direction]
        if !blocked(elf, direction)
          try_move!(elf, to_check[direction][1], moving_elves)
          moved = true
          break
        end
      end
      if !moved
        moving_elves[elf] = elf
      end
    end
    moved = length(setdiff(elves, keys(moving_elves)))
    elves = Set(keys(moving_elves))
    if step == 10
      println("After 10 steps: $(count_spaces(elves)) spaces.")
    elseif moved == 0
      println("Done after $step steps.")
      break
    end
  end
end

main()
