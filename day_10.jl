include("base.jl")

mutable struct State
  const save_period::Int
  next_save::Int
  const stop::Int

  clock::Int
  sprite::Int
  strength::Int
end

function tick(display)
  display.clock += 1
  if display.clock == display.next_save && display.clock <= display.stop
    display.strength += display.clock * display.sprite
    display.next_save += display.save_period
  end

  if (pixel = display.clock % display.save_period) == 0
    println()
  else
    print(abs(display.sprite + 1 - pixel) < 2 ? '#' : '.')
  end
end

open(Personal.to_path(ARGS[1]), "r") do input
  display = State(40, 20, 220, 0, 1, 0)
  for line in readlines(input)
    if line[1:4] == "addx"
      tick(display)
      tick(display)
      display.sprite += parse(Int, line[6:end])
    else
      tick(display)
    end
  end
  println("Signal strength: $(display.strength)")
end

