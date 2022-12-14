include("base.jl")

function add_line!(cave, start, stop)
  push!(cave, (start[1], start[2]))
  current = start
  direction = sign.(stop - start)
  while current != stop
    current .+= direction
    push!(cave, (current[1], current[2]))
  end
end

function main()  # julia day_14.jl input
  cave = Set()
  open(Personal.to_path(ARGS[1]), "r") do input
    for line in readlines(input)
      tokens = [parse(Int, m.match) for m in collect(eachmatch(r"\d+", line))]
      for i in 2:length(tokens)÷2
        add_line!(cave, [tokens[2i-3], tokens[2i-2]], [tokens[2i-1], tokens[2i]])
      end
    end
  end
  max_depth = maximum(z for (_, z) in cave)
  total_sand = 0
  part_1_done = false
  path = [[500, 0]]
  while !((500, 0) in cave)
    while true
      moved = false
      for direction in (0, -1, 1)
        if !((path[end][1]+direction, path[end][2]+1) in cave)
          push!(path, path[end] + [direction, 1])
          moved = true
          break
        end
      end
      if !part_1_done && path[end][2] == max_depth
        println("Part 1: ", total_sand)
        part_1_done = true
      elseif !moved || path[end][2] == max_depth + 1
        grain = pop!(path)
        push!(cave, (grain[1], grain[2]))
        total_sand += 1
        break
      end
    end
  end
  println("Part 2: ", total_sand)
end

main()
