include("base.jl")

valid(part, chamber) = 0 < part[1] < 8 && !(part in chamber) && part[2] > 0

function move(rock, direction, chamber)
  new_rock = [part .+ direction for part in rock]
  all(valid(part, chamber) for part in new_rock) ? new_rock : rock
end

function main()
  falling_rocks = [
    [[1, 1], [2, 1], [3, 1], [4, 1]],
    [[2, 1], [1, 2], [2, 2], [3, 2], [2, 3]],
    [[1, 1], [2, 1], [3, 1], [3, 2], [3, 3]],
    [[1, 1], [1, 2], [1, 3], [1, 4]],
    [[1, 1], [1, 2], [2, 1], [2, 2]],
  ]
  jet = open(input -> readlines(input)[1], Personal.to_path(ARGS[1]))
  chamber = Set()
  J = length(jet)
  num_rocks = 2022
  highest = [0 for _ in 1:7]
  time = 1
  seen = Dict()
  num_rocks = ARGS[2] == "1" ? 2022 : 1000000000000
  fall = 0
  found_cycle = false
  while fall < num_rocks
    fall += 1
    rock = [part .+ [2, maximum(highest)+3] for part in falling_rocks[((fall-1) % 5)+1]]
    while true
      wind = [jet[time] == '>' ? 1 : -1, 0]
      time = time < J ? time + 1 : 1
      old_y = rock[end][2]
      rock = move(move(rock, wind, chamber), [0, -1], chamber)
      if rock[end][2] == old_y
        union!(chamber, rock)
        for part in rock
          highest[part[1]] = max(highest[part[1]], part[2])
        end
        if !found_cycle
          top = maximum(highest)
          key = highest.-top, fall%5, time
          if key in keys(seen)
            previous_fall, previous_top = seen[key]
            cycle_length = fall - previous_fall
            cycle_height = top - previous_top
            cycles_remaining = (num_rocks - fall) ÷ cycle_length
            fall += cycles_remaining * cycle_length
            highest .+= cycles_remaining * cycle_height
            found_cycle = true
            for (x, y) in enumerate(highest)
              push!(chamber, [x, y])
            end
          end
          seen[key] = fall, top
        end
        break
      end
    end
  end
  println(maximum(highest))
end

main()
