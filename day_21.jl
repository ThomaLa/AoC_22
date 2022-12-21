include("base.jl")

function main()
  raw = Dict(split.(collect(open(readlines, Personal.to_path(ARGS[1]))), ": "))
  known = Dict()
  human_side = Set{String}()

  compute(a, op, b) = op == "+" ? a+b : op == "*" ? a*b : op == "-" ? a-b : a÷b
  solve(a, op, b) = op == "-" ? a+b : op == "/" ? a*b : op == "+" ? a-b : a÷b

  function hear(monkey)
    if !(monkey in keys(known))
      words = split(raw[monkey])
      if length(words) == 1
        known[monkey] = parse(Int, words[1])
      elseif  monkey in human_side
        known[monkey] = [hear(words[1]), words[2], hear(words[3])]
      else
        known[monkey] = compute(hear(words[1]), words[2], hear(words[3]))
      end
    end
    known[monkey]
  end

  println("Part 1: ", hear("root"))

  function find_human(monkey)
    if monkey == "humn"
      push!(human_side, monkey)
      return true
    elseif length(raw[monkey]) < 4
      return false
    elseif find_human(raw[monkey][1:4]) || find_human(raw[monkey][8:11])
      push!(human_side, monkey)
      return true
    end
    false
  end

  known = Dict{String, Any}("humn" => "x")
  find_human("root")
  equation, _, result = hear("root")
  while equation != "x"
    if typeof(equation[1]) == Int
      param, op, equation = equation
      if op == "-"
        result = -solve(result, "+", param)
      elseif op == "/"
        result = param ÷ result
      else
        result = solve(result, op, param)
      end
    else
      equation, op, param = equation
      result = solve(result, op, param)
    end
  end
  println("Part 2: ", result)
end

main()
