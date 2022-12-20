include("base.jl")

function handle(line, total_time)
  element_ids = Dict(zip(["ore", "clay", "obsidian", "geode"], 1:4))
  blueprint = zeros(Int, 4, 4)
  index = 10
  for robot in 1:4
    line_part = last(findnext("costs", line, index))+2:first(findnext('.', line, index))-1
    index = last(line_part) + 5
    for requirement in split(line[line_part], " and ")
      tokens = split(requirement)
      blueprint[robot, element_ids[tokens[2]]] = parse(Int, tokens[1])
    end
  end
  time_to_state = Dict()
  state_to_time = Dict()

  robots = [1, 0, 0, 0]
  resources = zeros(Int, 4)
  enough_robots = [maximum(blueprint[:, resource]) for resource in 1:3]

  best(robots, time, resources, dream_robot) = (
    time == 0 ?
      resources[4] :
    all(resources .≥ blueprint[dream_robot, :]) ?
      maximum(best(robots .+ [j==dream_robot for j in 1:4], time - 1,
                    resources .+ robots .- blueprint[dream_robot, :],
                    i) for i in 1:4 if i == 4
              || resources[i] ≤ time * (enough_robots[i] - robots[i])) :
      best(robots, time - 1, resources .+ robots, dream_robot)
  )

  maximum(best(robots, total_time, resources, i) for i in 1:4)
end


function main()
  open(Personal.to_path(ARGS[1]), "r") do input
    println("Part 1: ", 
            sum(i * handle(line, 24) for (i, line) in enumerate(readlines(input))))
  end
  open(Personal.to_path(ARGS[1]), "r") do input
    println("Part 2: ",
            prod(handle(line, 32) for (i, line) in enumerate(readlines(input)) if i < 4))
  end
end

main()
