include("base.jl")

open(Personal.to_path(ARGS[1]), "r") do input
  path = []  # e.g. ["", "/a", "/a/b"], path[end] is the current dir.
  sizes = Dict{String, Int}()
  children = Dict()
  small = 0
  for line in readlines(input)
    if line[3:4] ==  "cd"
      if (child = line[6:end]) == ".."  # Going back: fill sizes.
        sizes[path[end]] = sum(sizes[child] for child in children[path[end]])
        if sizes[path[end]] < 100000
          small += sizes[path[end]]
        end
        pop!(path)
      elseif child == "/"  # Going in, not much to do.
        push!(path, "")
      else
        push!(path, "$(path[end])/$child")
      end
    elseif line[1] != '$'  # Assuming the input isn't tricking me.
      size, child = split(line)
      full_child = "$(path[end])/$child"
      push!(get!(children, path[end], []), full_child)
      if size != "dir"
        sizes[full_child] = parse(Int, size)
      end
    end
  end
  for current in reverse(path)  # Finish filling sizes.
    sizes[current] = sum(sizes[child] for child in children[current])
    if sizes[current] < 100000
      small += sizes[current]
    end
  end
  println("Part 1: ", small)
  to_free = sizes[""] - 40000000
  just_sizes = [size for size in values(sizes)]
  println("Part 2: ", min(just_sizes[just_sizes .> to_free]...))
end

