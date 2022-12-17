include("base.jl")

struct Valve
  flow_rate::Int
  tunnels::Vector{String}
end

function to_valve(line)
  pattern = r"Valve (.*) has flow rate=(\d+); tunnels? leads? to valves? (.*)"
  tokens = match(pattern, line).captures
  tokens[1], Valve(parse(Int, tokens[2]), split(tokens[3], ", "))
end

function main()
  # Parse the input into a mapping valve_name -> Valve (see struct above).
  valves = Dict(collect(to_valve.(
    open(input -> collect(readlines(input)),
         Personal.to_path(ARGS[1])))))

  # Compute shortest path between rooms.
  paths = Dict(start => Dict(dest => 1 for dest in valves[start].tunnels)
               for start in keys(valves))
  for mid in keys(paths), start in keys(paths), dest in keys(paths)
    if start == mid || mid == dest || start == dest
      continue
    end
    paths[start][dest] = min(get(paths[start], dest, 30),
                get(paths[start], mid, 30) + get(paths[dest], mid, 30))
  end 
  # Drop irrelevant rooms (no flow unless it's the start)
  relevant(valve) = valve == "AA" || valves[valve].flow_rate > 0
  paths = Dict{String, Dict{String, Int}}(
               k => filter(relevant ∘ first, v)
               for (k, v) in pairs(filter!(relevant ∘ first, paths)))
  for (start, neighbors) in pairs(paths)
    delete!(neighbors, start)
    for neighbor in keys(neighbors)
      neighbors[neighbor] += 1
    end
  end
  # Use more efficient data structures...
  encode = Dict{String, Int}(name => 1 << i for (i, name) in enumerate(keys(paths)))
  flows = Dict{String, Int}(name => valves[name].flow_rate for name in keys(encode))
  println("Preprocessing done.")

  # Nothing fancy: best[open_valves] is the best flow with these valves open.
  function visit(position, time_left, open_valves, flow, best)
    best[open_valves] = max(get(best, open_valves, 0), flow)
    for (neighbor, neighbor_flow) in pairs(flows)
      if neighbor == position
        continue
      end
      new_time_left = time_left - paths[position][neighbor]
      neighbor_bit = encode[neighbor]
      if neighbor_bit & open_valves > 0 || new_time_left ≤ 0
        continue
      end
      visit(neighbor, new_time_left, open_valves | neighbor_bit,
            flow + new_time_left * flows[neighbor], best)
    end
  end

  # Profit.
  best_1 = Dict{Int, Int}()
  visit("AA", 30, 0, 0, best_1)
  println("Part 1: ", maximum(values(best_1)))
  best_2 = Dict{Int, Int}()
  visit("AA", 26, 0, 0, best_2)
  println("Part 2: ", maximum(flow_human + flow_elephant
    for (open_by_human, flow_human) in pairs(best_2)
    for (open_by_elephant, flow_elephant) in pairs(best_2)
    if open_by_human & open_by_elephant == 0
  ))
end

main()
