include("base.jl")

digits = Dict(zip("=-012", -2:2))
to_decimal(snafu) = sum(5 ^ (i-1) * digits[c] for (i, c) in enumerate(reverse(snafu)))
snaf = Dict(zip(0:4, "=-012"))
to_snafu(d) = ((d+2) ÷ 5 > 0 ? to_snafu((d+2) ÷ 5) : "") * snaf[(d+2) % 5]

function main()
  println(to_snafu(sum(to_decimal.(open(readlines, Personal.to_path(ARGS[1]))))))
end

main()
