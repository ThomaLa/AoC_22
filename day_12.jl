include("base.jl")


function main()  # julia day_12.jl input part
  heights = open(input -> collect(readlines(input)), Personal.to_path(ARGS[1]))
  boundary = []
  visited = Set()
  start = ARGS[2] == "1" ? 'S' : 'a'

  z(c) = c > 'Z' ? c : c == 'S' ? 'a' : 'z'
  for (y, line) in enumerate(heights), (x, height) in enumerate(line)
    if height == start
      push!(boundary, (0, x, y))
      push!(visited, (x, y))
    end
  end

  while true
    distance, x, y = popfirst!(boundary)
    for (nx, ny) in ((x+1,y), (x-1,y), (x,y+1), (x,y-1))
      if (!((nx, ny) in visited)
          && checkbounds(Bool, heights, ny)
          && checkbounds(Bool, heights[ny], nx)
          && z(heights[ny][nx]) - z(heights[y][x]) ≤ 1)
        if heights[ny][nx] == 'E'
          println(distance + 1)
          return
        end
        push!(boundary, (distance + 1, nx, ny))
        push!(visited, (nx, ny))
      end
    end
  end
end

main()
