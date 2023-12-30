using Documenter
using CantStop

makedocs(
    sitename = "CantStop",
    format = Documenter.HTML(),
    modules = [CantStop]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
