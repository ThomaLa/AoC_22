include("base.jl")

function compare(left, right)
  if typeof(left) == Int && typeof(right) == Int
    return sign(right - left)
  elseif typeof(left) != Int && typeof(right) != Int
    for (l, r) in zip(left, right)
      if (inner = compare(l, r)) != 0
        return inner
      end
    end
    return sign(length(right) - length(left))
  elseif typeof(left) == Int
    return compare([left], right)
  else
    return compare(left, [right])
  end
end

function parse(left, right)
  left = eval(Meta.parse(left))
  right = eval(Meta.parse(right))
  compare(left, right)
end

function main()  # julia day_13.jl input
  pairs = open(input -> collect(split.(split(read(input, String), "\n\n"))), Personal.to_path(ARGS[1]))
  println("Part 1: ", sum(i for (i, pair) in enumerate(pairs) if parse(pair...) == 1))
  flat = [eval(Meta.parse(l)) for l in Iterators.flatten(pairs)]
  sort!(push!(flat, [[2]], [[6]]), lt=((x, y) -> compare(x, y) == 1))
  println("Part 2: ", prod(i for (i, val) in enumerate(flat) if val == [[2]] || val == [[6]]))
end

main()
