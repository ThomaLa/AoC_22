include("base.jl")

int(s) = parse(Int, s)

function my_parse(expr)
  op, right = split(expr)[2:3]
  x -> op == "+" ? x + int(right) : x * (right == "old" ? x : int(right))
end

function create_monkey(lines)
  starting_items = int.(split(split(lines[2], ": ")[2], ", "))
  stress = my_parse(split(lines[3], " = ")[2])
  divisible_by = int(split(lines[4], " ")[end])
  true_monkey = int(split(lines[5], " ")[end])
  false_monkey = int(split(lines[6], " ")[end])
  destination = x -> x % divisible_by == 0 ? true_monkey : false_monkey
  starting_items, stress, destination, divisible_by
end

function turn!(monkeys, items, activities, manage)
  for (i, (stress, destination)) in enumerate(monkeys)
    activities[i] += length(items[i])
    while !isempty(items[i])
      item = (manage ∘ stress ∘ popfirst!)(items[i])
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
