include("base.jl")

function mix(original, times)
  mixed = collect(original)
  for _ in 1:times, number in original
    old_i = findfirst(==(number), mixed)
    new_i = mod(old_i + last(number) - 1, length(original) - 1) + 1
    deleteat!(mixed, old_i)
    insert!(mixed, new_i, number)
  end
  start = first(findfirst(x -> last(x) == 0, mixed))
  k = 1000
  println(sum(last(mixed[(start + n - 1) % length(mixed) + 1]) for n in 1k:1k:3k))
end

function main()
  raw = parse.(Int, collect(open(readlines, Personal.to_path(ARGS[1]))))
  mix(enumerate(raw), 1)
  mix(enumerate(raw .* 811589153), 10)
end

main()
