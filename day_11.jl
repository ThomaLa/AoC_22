include("base.jl")

int(s) = parse(Int, s)

function create_monkey(lines)
  starting_items = int.(split((last ∘ split)(lines[2], ": "), ", "))
  stress = (eval ∘ Meta.parse)("old -> " * (last ∘ split)(lines[3], " = "))
  divisible_by = (int ∘ last ∘ split)(lines[4])
  true_monkey = (int ∘ last ∘ split)(lines[5])
  false_monkey = (int ∘ last ∘ split)(lines[6])
  destination = x -> x % divisible_by == 0 ? true_monkey : false_monkey
  starting_items, stress, destination, divisible_by
end

function turn!(monkeys, items, activities, manage)
  for (i, (stress, destination)) in enumerate(monkeys)
    activities[i] += length(items[i])
    while !isempty(items[i])
      item = (manage ∘ Base.invokelatest)(stress, popfirst!(items[i]))
      push!(items[1 + destination(item)], item)
    end
  end
end

function main()  # julia day_11.jl input part
  items = []
  monkeys = []
  to_manage = 1
  part = int(ARGS[2])
  open(Personal.to_path(ARGS[1]), "r") do input
    for token in split(read(input, String), "\n\n")
      starts, stress, destination, factor = create_monkey(split(token, '\n'))
      to_manage *= factor
      push!(items, starts)
      push!(monkeys, (stress, destination))
    end
  end
  manage = x -> part == 1 ? x ÷ 3 : x % to_manage
  activities = [0 for _ in items]
  for i in 1:(part == 1 ? 20 : 10_000)
    turn!(monkeys, items, activities, manage)
  end
  (println ∘ prod)(sort(activities)[end-1:end])
end

main()
