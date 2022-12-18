include("base.jl")

function main()
  cubes = Set()
  facing = [[0,0,1], [0,1,0], [1,0,0], [0,0,-1], [0,-1,0], [-1,0,0]]
  surface = 0
  open(Personal.to_path(ARGS[1]), "r") do input
    for line in readlines(input)
      cube = parse.(Int, split(line, ','))
      surface += 6 - 2count(cube + dir in cubes for dir in facing)
      push!(cubes, cube)
    end
  end
  println("Part 1: ", surface)
  
  boundary = Set([maximum(cubes) + [1, 0, 0]])
  shell = Set()
  touching = [[x,y,z] for x in -1:1, y in -1:1, z in -1:1 if x|y|z != 0]
  surface = 0
  while !isempty(boundary)
    cube = pop!(boundary)
    if cube in shell || !any(cube + dir in cubes for dir in touching)
      continue
    end
    surface += count(cube + direction in cubes for direction in facing)
    push!(shell, cube)
    union!(boundary, [cube + dir for dir in facing if !(cube + dir in cubes)])
  end
  println("Part 2: ", surface)
end

main()
