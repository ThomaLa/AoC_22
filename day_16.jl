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

struct State
  pos_1::String
  pos_2::String
  open_valves::Int
end

function main()
  valves = Dict(collect(to_valve.(
    open(input -> collect(readlines(input)),
         Personal.to_path(ARGS[1])))))

  paths = Dict(start => Dict(dest => 1 for dest in valves[start].tunnels)
               for start in keys(valves))
  for mid in keys(paths), start in keys(paths), dest in keys(paths)
    if start == mid || mid == dest || start == dest
      continue
    end
    paths[start][dest] = min(get(paths[start], dest, 30),
                get(paths[start], mid, 30) + get(paths[dest], mid, 30))
  end 
  relevant(valve) = valve == "AA" || valves[valve].flow_rate > 0
  paths = Dict(k => filter(relevant ∘ first, v) for (k, v) in
               pairs(filter!(relevant ∘ first, paths)))
  for (start, neighbors) in pairs(paths)
    delete!(neighbors, start)
  end

  best = 0

  function explore_alone(flow, open_valves, time_spent, position)
    best = max(best, flow)
    for (neighbor, distance) in pairs(paths[position])
      if neighbor in open_valves || time_spent + distance > 29
        continue
      end
      explore_alone(
        flow + (29 - time_spent - distance) * valves[neighbor].flow_rate,
        union(open_valves, [neighbor]),
        time_spent + distance + 1,
        neighbor)
    end
  end

  bitmap(valves) = isempty(valves) ? 1 : sum(2^i for (i, room) in enumerate(keys(paths)) if room in valves)
  seen = Dict{State, Int}()
  best = 0
  function ok!(seen, valves, new_flow, pos_1, pos_2)
    if pos_1 < pos_2
      tmp = pos_1
      pos_1 = pos_2
      pos_2 = pos_1
    end
    state = State(pos_1, pos_2, bitmap(valves))
    if new_flow > best
      println("$(bitstring(state.open_valves)[end-16:end]) $pos_1 $pos_2: $new_flow")
      seen[state] = new_flow
      best = new_flow
      return true
    elseif get(seen, state, 0) < new_flow
      seen[state] = new_flow
      return best < 1000 || 2new_flow > best
    end
    return false
  end
  function explore_together(flow, open_valves, time_1, pos_1, time_2, pos_2)
    for (neigh_1, dist_1) in pairs(paths[pos_1])
      if neigh_1 in open_valves
        continue
      end
      for (neigh_2, dist_2) in pairs(paths[pos_2])
        if neigh_2 in open_valves
          continue
        end
        new_time_1 = time_1 + dist_1 
        new_time_2 = time_2 + dist_2
        if max(new_time_1, new_time_2) < 26 && neigh_1 != neigh_2
          new_open_valves = union(open_valves, [neigh_1, neigh_2])
          new_flow = flow + (25 - time_1 - dist_1) * valves[neigh_1].flow_rate + (
                             25 - time_2 - dist_2) * valves[neigh_2].flow_rate
          b = bitmap(new_open_valves)
          if ok!(seen, new_open_valves, new_flow, neigh_1, neigh_2)
            explore_together(
              new_flow,
              new_open_valves,
              new_time_1 + 1, neigh_1,
              new_time_2 + 1, neigh_2)
          end
        elseif new_time_1 < 26
          new_open_valves = union(open_valves, [neigh_1])
          new_flow = flow + (25 - time_1 - dist_1) * valves[neigh_1].flow_rate
          b = bitmap(new_open_valves)
          if ok!(seen, new_open_valves, new_flow, neigh_1, pos_2)
            explore_together(
              new_flow,
              new_open_valves,
              new_time_1 + 1, neigh_1,
              time_2, pos_2)
          end
        elseif new_time_2 < 26
          new_open_valves = union(open_valves, [neigh_2])
          new_flow = flow + (25 - time_2 - dist_2) * valves[neigh_2].flow_rate
          b = bitmap(new_open_valves)
          if ok!(seen, new_open_valves, new_flow, pos_1, neigh_2)
            explore_together(
              new_flow,
              new_open_valves,
              time_1, pos_1,
              new_time_2 + 1, neigh_2)
          end
        end
      end
    end
  end

  explore_alone(0, Set(), 0, "AA")
  println("Part 1: ", best)
  best = 0
  explore_together(0, Set(), 0, "AA", 0, "AA")
  println("Part 2: ", best)

end

main()
