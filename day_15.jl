include("base.jl")


function main()  # julia day_15.jl input size
  number = r"-?\d+"
  special_row = parse(Int, ARGS[2])
  search_width = 2 * special_row
  impossible_places = [[] for _ in 0:search_width]
  beacons = Dict()
  beacons[special_row] = Set()
  open(Personal.to_path(ARGS[1]), "r") do input
    for line in readlines(input)
      coordinates = [parse(Int, m.match) for m in eachmatch(number, line)]
      sensor = coordinates[1:2]
      beacon = coordinates[3:4]
      if !(beacon[2] in keys(beacons))
        beacons[beacon[2]] = Set()
      end
      push!(beacons[beacon[2]], beacon[1])
      distance = sum(abs.(sensor - beacon))
      for y in max(sensor[2]-distance, 0):min(sensor[2]+distance, search_width)
        width = distance - abs(sensor[2] - y)
        push!(impossible_places[y + 1],
              [sensor[1]-width, sensor[1]+width])
      end
    end
  end

  for (y, constraints) in enumerate(impossible_places)
    sort!(constraints)
    highest = constraints[1][2]
    if y - 1 == special_row
      println("Part 1: ", maximum(c[2] for c in constraints) - constraints[1][1] - length(beacons[special_row]) + 1)
    end
    for constraint in constraints
      if constraint[1] > highest + 1
        println("Part 2: ", (highest + 1) * 4000000 + y - 1)
        break
      else
        highest = max(highest, constraint[2])
      end
    end
  end
end

main()
