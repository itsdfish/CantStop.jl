using Documenter
using CantStop

makedocs(
    warnonly = true,
    sitename="CantStop",
    format=Documenter.HTML(
        assets=[
            asset(
                "https://fonts.googleapis.com/css?family=Montserrat|Source+Code+Pro&display=swap",
                class=:css,
            ),
        ],
        collapselevel=1,
    ),
    modules=[
        CantStop, 
        # Base.get_extension(SequentialSamplingModels, :TuringExt),  
        # Base.get_extension(SequentialSamplingModels, :PlotsExt) 
    ],
    pages=[
        "Home" => "index.md",
        "Basic Usage" => "basic_usage.md",
        "API" => "api.md",
        "Internal Methods" => "internal_methods.md",
    ]
)

deploydocs(
    repo="github.com/itsdfish/CantStop.jl.git",
)