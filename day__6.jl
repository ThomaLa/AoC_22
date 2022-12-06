include("base.jl")

open(Personal.to_path(ARGS[1]), "r") do input
  size = parse(Int, ARGS[2])
  for line in readlines(input)
    for i in 1:length(line)-size+1
      if length(Set(line[i:i+size-1])) == size
        println(i+size-1)
        break
      end
    end
  end
end

