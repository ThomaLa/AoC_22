include("base.jl")

open(Personal.to_path(ARGS[1]), "r") do input
  priority(c) = c < 'a' ? 27 + c - 'A' : 1 + c - 'a'
  group = ["","",""]
  costs = 0
  badges = 0
  for (i, rucksack) in enumerate(readlines(input))
    half_size = length(rucksack) ÷ 2
    costs += sum(priority.(intersect(rucksack[half_size + 1:end], rucksack[1:half_size])))
    group[i%3 + 1] = rucksack
    if i % 3 == 0
      badges += priority(intersect(group...)[1])
    end
  end
  println("1: $costs, 2: $badges")
end

