include("base.jl")

function main()
  map = Vector{String}()
  limits = Dict{Char, Dict{Int, Int}}(c => Dict() for c in "NSWE")
  done = false
  instructions = ""
  open(Personal.to_path(ARGS[1])) do input
    for (y, line) in enumerate(readlines(input))
      if isempty(line)
        done = true
        continue
      elseif done
        instructions = split(replace(line, "L" => " L ", "R" => " R "))
        break
      end
      push!(map, line)
      for (x, cell) in enumerate(line)          
        if cell != ' '
          limits['E'][y] = x
          limits['S'][x] = y
          if !(y in keys(limits['W']))
            limits['W'][y] = x
          end
          if !(x in keys(limits['N']))
            limits['N'][x] = y 
          end
        end
      end
    end
  end
  added = Dict('N' => [0, -1], 'S' => [0, 1], 'E' => [1, 0], 'W' => [-1, 0])
  turn = Dict("L" => Dict(zip("NESW", "WNES")), "R" => Dict(zip("WNES", "NESW")))
  opposite = Dict(zip("NESW", "SWNE"))
  score = Dict(zip("ESWN", 0:3))

  function move(position, heading, limits, map)
    ew = heading in "EW"
    x, y = position
    attempt = (
      (ew ? x : y) == limits[heading][ew ? y : x] ?
      (ew ? [limits[opposite[heading]][y], y] : [x, limits[opposite[heading]][x]]) :
      position .+ added[heading]
    )
    map[attempt[2]][attempt[1]] == '#' ? position : attempt
  end

  position = [limits['W'][1], 1]
  heading = 'E'
  for instruction in instructions
    if instruction in keys(turn)
      heading = turn[instruction][heading]
    else
      for _ in 1:parse(Int, instruction)
        position = move(position, heading, limits, map)
      end
    end
  end
  println("$position $heading:\t", 1000 * position[2] + 4 * position[1] + score[heading])
  start = [limits['W'][limits['N'][1]-1], limits['N'][1]]
  stitches = Dict()

  mirror((x, y, heading)) = [x, y, opposite[heading]]
  function next_scan((x, y, heading), side)
    new_x, new_y = [x, y] .+ added[turn[side][heading]]
    if !checkbounds(Bool, map, new_y) || !checkbounds(Bool, map[new_y], new_x) || map[new_y][new_x] == ' '
      return (x, y, turn[side][heading])
    end
    view_x, view_y = [new_x, new_y] .+ added[heading]
    if !checkbounds(Bool, map, view_y) || !checkbounds(Bool, map[view_y], view_x) || map[view_y][view_x] == ' '
      return (new_x, new_y, heading)
    end
    (view_x, view_y, opposite[turn[side][heading]])
  end

  current = [(start[1], start[2] - 1, 'W'), (start[1] - 1, start[2], 'N')]
  initial_headings = "WN"
  while !(current[1] in keys(stitches))
    if initial_headings[1] == opposite[current[1][3]] || current[2] in keys(stitches)
      ahead = next_scan(current[1], "R")
      while ahead[1:2] == current[1][1:2] || ahead[3] == current[1][3]
        current[1] = ahead
        ahead = next_scan(current[1], "R")
      end
      current = [ahead, current[1]]
      initial_headings = join(c[3] for c in current)
    end
    stitches[current[1]] = mirror(current[2])
    stitches[current[2]] = mirror(current[1])
    current = [next_scan(current[1], "R"), next_scan(current[2], "L")]
  end


  function move2(position, heading, limits, map)
    ew = heading in "EW"
    x, y = position
    attempt = get(stitches, (x, y, heading), vcat(position .+ added[heading], [heading]))
    map[attempt[2]][attempt[1]] == '#' ? [x, y, heading] : attempt
  end

  path = Dict(y => Dict() for y in 1:length(map))
  position = [limits['W'][1], 1]
  heading = 'E'
  for instruction in instructions
    if instruction in keys(turn)
      heading = turn[instruction][heading]
    else
      for _ in 1:parse(Int, instruction)
        x, y, heading = move2(position, heading, limits, map)
        path[y][x] = heading
        position = [x, y]
      end
    end
  end
  println("$position $heading:\t", 1000 * position[2] + 4 * position[1] + score[heading])
end

main()
