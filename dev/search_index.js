var documenterSearchIndex = {"docs":
[{"location":"api/#Required","page":"API","title":"Required","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"The API requires you to create a subtype of AbstractPlayer with extensions of the methods below.","category":"page"},{"location":"api/#Types","page":"API","title":"Types","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"AbstractPlayer","category":"page"},{"location":"api/#CantStop.AbstractPlayer","page":"API","title":"CantStop.AbstractPlayer","text":"AbstractPlayer\n\nAn abstract type for a player. Subtypes of AbstractPlayer must have the fields described below.\n\nFields\n\nid::Symbol: player id\npieces::Vector{Symbol}: a vector of 12 pieces where each piece has the value id. \npiece_reserve::Vector{}: an optional vector for keeping track of pieces which will replace runners unless a bust occurs\n\nIn addition, for a subtype MyPlayer <: AbstractPlayer, the API requires the following constructor to ensure  the correct number of pieces are provided. \n\nConstructor\n\nMyPlayer(;id, pieces=fill(id, 12)) = MyPlayer(id, pieces)\n\n\n\n\n\n","category":"type"},{"location":"api/#Methods","page":"API","title":"Methods","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"select_runners\ntake_chance\nselect_positions\npostbust_cleanup!\npoststop_cleanup!","category":"page"},{"location":"api/#CantStop.select_runners","page":"API","title":"CantStop.select_runners","text":"select_runners(::Type{<:AbstractGame}, player::AbstractPlayer, board, outcome, num_roll)\n\nDuring the selection phase, select runners based on the outcome of a dice roll. \n\nArguments\n\n::Type{<:AbstractGame}: an abstract game type \nplayer::AbstractPlayer: an subtype of a abstract player\noutcome: outcome of dice roll\nboard::Dict{Int,T}: a dictionary representing columns 2-12. Each row in a column is a vector of symbols which contain the player ids \nnum_roll: a count of dice rolls for a given round. Max is 2.\n\nReturns\n\nc_idx::Vector{Int}: a vector of column indices\nr_idx::Vector{Int}: a vector of row indices\n\n\n\n\n\n","category":"function"},{"location":"api/#CantStop.take_chance","page":"API","title":"CantStop.take_chance","text":"take_chance(::Type{<:AbstractGame}, player::AbstractPlayer, board)\n\nDuring the decision phase, decide whether to take a chance to advance the runners, or set your pieces in  the current location of the runners. \n\nArguments\n\n::Type{<:AbstractGame}: an abstract game type \nplayer::AbstractPlayer: an subtype of a abstract player\nboard::Dict{Int,T}: a dictionary representing columns 2-12. Each row in a column is a vector of symbols which contain the player ids \n\nReturns\n\ndecision::Bool: true if take chance, false otherwise\n\n\n\n\n\n","category":"function"},{"location":"api/#CantStop.select_positions","page":"API","title":"CantStop.select_positions","text":"select_positions(::Type{<:AbstractGame}, player::AbstractPlayer, board, outcome)\n\nDuring the decision phase and after deciding to take chance, select positions based on the outcome of rolling dice.  Two column indices are determined by summing two pairs of dice. \n\nArguments\n\n::Type{<:AbstractGame}: an abstract game type \nplayer::AbstractPlayer: an subtype of a abstract player\noutcome: outcome of dice roll\nboard::Dict{Int,T}: a dictionary representing columns 2-12. Each row in a column is a vector of symbols which contain the player ids \n\nReturns\n\nc_idx::Vector{Int}: a vector of column indices\nr_idx::Vector{Int}: a vector of row indices\n\n\n\n\n\n","category":"function"},{"location":"api/#CantStop.postbust_cleanup!","page":"API","title":"CantStop.postbust_cleanup!","text":"postbust_cleanup!(::Type{<:AbstractGame}, player::AbstractPlayer)\n\nPerforms cleanup and book keeping after a \"bust\" (i.e., a roll that does not provide a valid move).\n\nArguments\n\n::Type{<:AbstractGame}: an abstract game type \nplayer::AbstractPlayer: an subtype of a abstract player\n\nReturns\n\nnothing\n\n\n\n\n\n","category":"function"},{"location":"api/#CantStop.poststop_cleanup!","page":"API","title":"CantStop.poststop_cleanup!","text":"poststop_cleanup(::Type{<:AbstractGame}, player::AbstractPlayer)\n\nPerforms cleanup and book keeping after deciding to stop rolling during the decision phase.\n\nArguments\n\n::Type{<:AbstractGame}: an abstract game type \nplayer::AbstractPlayer: an subtype of a abstract player\n\nReturns\n\nnothing\n\n\n\n\n\n","category":"function"},{"location":"api/#Optional-Types","page":"API","title":"Optional Types","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"It is possible to create variations of the game by creating a new subtype of AbstractGame and  defining new internal methods as needed. ","category":"page"},{"location":"api/","page":"API","title":"API","text":"AbstractGame","category":"page"},{"location":"api/#CantStop.AbstractGame","page":"API","title":"CantStop.AbstractGame","text":"AbstractGame\n\nAn abstract game type for Can't Stop. \n\nThe following fields are required in order to work with default methods: \n\nFields\n\ndice::Dice: an object resepresenting four dice \nboard::Dict{Int,T}: a dictionary representing columns 2-12. Each column is a vector of symbol vectors which contain the player ids \nc_idx::Vector{Int}: column indices of starting position of active piece \nr_idx::Vector{Int}: row indices of starting position of active pieace\npieces::Dict{Symbol,Vector{Symbol}}: inactive pieces for each player: player_id -> pieces\npiece_reserve::Vector{Symbol}: holds pieces for runners started at the beginning of the column\n\n\n\n\n\n","category":"type"},{"location":"api/#Available-Types","page":"API","title":"Available Types","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"Game","category":"page"},{"location":"api/#CantStop.Game","page":"API","title":"CantStop.Game","text":"Game{T} <: AbstractGame\n\nFields\n\ndice::Dice: an object resepresenting four dice \nboard::Dict{Int,T}: a dictionary representing columns 2-12. Each row in a column is a vector of symbols which contain the player ids \nc_idx::Vector{Int}: column indices of starting position of active piece \nr_idx::Vector{Int}: row indices of starting position of active pieace\npieces::Dict{Symbol,Vector{Symbol}}: inactive pieces for each player: player_id -> pieces\n\nConstructor\n\nGame(;dice=Dice(), board=make_board())\n\n\n\n\n\n","category":"type"},{"location":"api/#Utilities","page":"API","title":"Utilities","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"The following methods might be helpful for defining the required methods above.","category":"page"},{"location":"api/","page":"API","title":"API","text":"get_active_locations\nget_runner_locations\nis_valid_runner\nlist_sums\nreserve_piece!\nsimulate","category":"page"},{"location":"api/#CantStop.get_active_locations","page":"API","title":"CantStop.get_active_locations","text":"get_active_locations(board, player_id)\n\nReturns the location of active pieces, which includes runners. \n\nArguments\n\nboard::Dict{Int,T}: a dictionary representing columns 2-12. Each row in a column is a vector of symbols which contain the player ids \nplayer_id::Symbol: id of player\n\nReturns\n\nc_idx: column indices of active positions\nr_idx: row indices of active positions\n\n\n\n\n\n","category":"function"},{"location":"api/#CantStop.get_runner_locations","page":"API","title":"CantStop.get_runner_locations","text":"get_runner_locations(board)\n\nReturns runner locations. \n\nArguments\n\nboard::Dict{Int,T}: a dictionary representing columns 2-12. Each row in a column is a vector of symbols which contain the player ids \n\nReturns\n\nc_idx: column indices\nr_idx: row indices\n\n\n\n\n\n","category":"function"},{"location":"api/#CantStop.list_sums","page":"API","title":"CantStop.list_sums","text":"list_sums(outcome)\n\nLists all unique sum of combinations of the outcome of rolling dice\n\nArguments\n\noutcome: the results of rolling the dice\n\n\n\n\n\n","category":"function"},{"location":"api/#CantStop.reserve_piece!","page":"API","title":"CantStop.reserve_piece!","text":"reserve_piece!(player::AbstractPlayer)\n\nTranfer piece to reserve for bookkeeping. \n\nArguments\n\nplayer::AbstractPlayer: an object which is a subtype of AbstractPlayer\n\n\n\n\n\n","category":"function"},{"location":"api/#CantStop.simulate","page":"API","title":"CantStop.simulate","text":"simulate(game::AbstractGame, players)\n\nSimulate CantStop until a player has won. \n\nArguments\n\ngame::AbstractGame: an abstract game object \nplayers: a vector of players where elements are a subtype of a abstract player\n\n\n\n\n\n","category":"function"},{"location":"internal_methods/","page":"Internal Methods","title":"Internal Methods","text":"Modules = [CantStop]\nOrder   = [:type, :function]\nPublic = false","category":"page"},{"location":"internal_methods/#CantStop.Dice","page":"Internal Methods","title":"CantStop.Dice","text":"Dice\n\nAn object for rolling dice. \n\nFields\n\nn::Int: number of rolls \nsides::Int: number of sides per die\n\nConstructors\n\nDice(4, 6)\nDice(;n=4, sides=6)\n\n\n\n\n\n","category":"type"},{"location":"internal_methods/#CantStop.clear_runners!-Tuple{Any}","page":"Internal Methods","title":"CantStop.clear_runners!","text":"clear_runners!(game)\n\nClear runners from board following a bust. \n\nArguments\n\ngame::AbstractGame: an abstract game object \n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.decision_phase!-Union{Tuple{G}, Tuple{G, AbstractPlayer}} where G<:AbstractGame","page":"Internal Methods","title":"CantStop.decision_phase!","text":"decision_phase!(game::AbstractGame, player::AbstractPlayer)\n\nImplements the decision phase in which the player decides to roll the dice for the possibility of  moving the runners. The two methods named decide! are called during this phase.\n\nArguments\n\ngame::AbstractGame: an abstract game object \nplayer::AbstractPlayer: an subtype of a abstract player\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.get_board-Tuple{AbstractGame}","page":"Internal Methods","title":"CantStop.get_board","text":"get_board(game::AbstractGame)\n\nReturns a copy of the board. \n\nArguments\n\ngame::AbstractGame: an abstract game object \n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.is_bust-Tuple{AbstractGame, Any}","page":"Internal Methods","title":"CantStop.is_bust","text":"is_bust(game::AbstractGame, outcome; fun=any)\n\nChecks whether a dice roll is a bust i.e., does not allow a valid move. \n\nArguments\n\ngame::AbstractGame: an abstract game object for Can't Stop\noutcome: a vector of dice outcomes \n\nKeywords\n\nfun=any: a function for testing the combinations \n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.is_combination-Tuple{Any, Any}","page":"Internal Methods","title":"CantStop.is_combination","text":"is_combination(outcome, c_idx)\n\nTests whether columns are a possible some of dice outcome.\n\nArguments\n\noutcome: a vector of dice outcomes \nc_idx: a vector of sums based on pairs of dice outcomes \n\nKeywords\n\nfun=all: a function for testing the combinations \n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.is_valid_runner-NTuple{5, Any}","page":"Internal Methods","title":"CantStop.is_valid_runner","text":"is_valid_runner(board, outcome, c_idx, r_idx, player_id)\n\nEvaluates whether a proposed runner is valid.\n\nArguments\n\nboard::Dict{Int,T}: a dictionary representing columns 2-12. Each row in a column is a vector of symbols which contain the player ids \noutcome: the results of rolling the dice\nc_idx: column indices of proposed positions\nr_idx: row indices of proposed positions\nplayer_id: id of player\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.move!-Tuple{AbstractGame, Any, Any}","page":"Internal Methods","title":"CantStop.move!","text":"move!(game::AbstractGame, c_idx, r_idx)\n\nMove runner to location determined by column and row index\n\nArguments\n\ngame::AbstractGame: an abstract game object \nc_idx: column index of position \nr_idx: row index of position \n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.play_round!-Tuple{AbstractGame, AbstractPlayer}","page":"Internal Methods","title":"CantStop.play_round!","text":"play_round!(game::AbstractGame, player::AbstractPlayer)\n\nPlay one round with a specified player.\n\nArguments\n\ngame::AbstractGame: an abstract game object \nplayer::AbstractPlayer: an subtype of a abstract player\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.remove_pieces!-Tuple{AbstractGame, Any}","page":"Internal Methods","title":"CantStop.remove_pieces!","text":"remove_pieces!(game::AbstractGame, player_id)\n\nArguments\n\ngame::AbstractGame: an abstract game object for Can't Stop\nplayer_id::Symbol: id of player\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.replace_runners!-Tuple{AbstractGame, Any}","page":"Internal Methods","title":"CantStop.replace_runners!","text":"replace_runners!(game::AbstractGame, player_id)\n\nReplaces runners with player_id.\n\nArguments\n\ngame::AbstractGame: an abstract game object \nplayer::AbstractPlayer: an subtype of a abstract player\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.runner_selection_phase!-Union{Tuple{G}, Tuple{G, AbstractPlayer}} where G<:AbstractGame","page":"Internal Methods","title":"CantStop.runner_selection_phase!","text":"runner_selection_phase!(game::AbstractGame, player::AbstractPlayer)\n\nImplements the runner selection phase in which the player performs two dice rolls to select runners. The function select_runners! is called during this phase.\n\nArguments\n\ngame::AbstractGame: an abstract game object \nplayer::AbstractPlayer: an subtype of a abstract player\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.setup!-Tuple{AbstractPlayer, Any}","page":"Internal Methods","title":"CantStop.setup!","text":"setup!(player::AbstractPlayer, ids)\n\nPerform initial setup after cards are delt, but before the game begins.\n\nArguments\n\nplayer: a player object\nids: all player ids\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.validate_runner-Tuple{AbstractGame, Vararg{Any, 4}}","page":"Internal Methods","title":"CantStop.validate_runner","text":"validate_runner(game::AbstractGame, outcome, c_idx, r_idx, player_id)\n\nThrows an error if the proposed position of a runner is invalid .\n\nArguments\n\ngame::AbstractGame: an abstract game object for Can't Stop\noutcome: a vector of dice outcomes \nc_idx: column indices of active positions\nr_idx: row indices of active positions\nplayer_id: id of player\n\n\n\n\n\n","category":"method"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"using CantStop\nimport CantStop: postbust_cleanup!\nimport CantStop: poststop_cleanup!\nimport CantStop: select_runners\nimport CantStop: select_positions\nimport CantStop: take_chance","category":"page"},{"location":"basic_usage/#Introduction","page":"Basic Usage","title":"Introduction","text":"","category":"section"},{"location":"basic_usage/#Example","page":"Basic Usage","title":"Example","text":"","category":"section"},{"location":"basic_usage/#Dependencies","page":"Basic Usage","title":"Dependencies","text":"","category":"section"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"using CantStop\nimport CantStop: postbust_cleanup!\nimport CantStop: poststop_cleanup!\nimport CantStop: select_runners\nimport CantStop: select_positions\nimport CantStop: take_chance","category":"page"},{"location":"basic_usage/#Make-Player-Type","page":"Basic Usage","title":"Make Player Type","text":"","category":"section"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"struct Player <: AbstractPlayer\n    id::Symbol\n    pieces::Vector{Symbol}\nend\nPlayer(;id) = Player(id, fill(id, 12))","category":"page"},{"location":"basic_usage/#Required-Methods","page":"Basic Usage","title":"Required Methods","text":"","category":"section"},{"location":"basic_usage/#select_runners","page":"Basic Usage","title":"select_runners","text":"","category":"section"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"function select_runners(game::AbstractGame, player::Player, outcome, i)\n    c_idx = Int[]\n    r_idx = Int[]\n    # on first attempt, 2 positions are given, but only 1 position on the second attempt\n    for j ∈ 1:(3 - i)\n        # columns are the sum of the first two dice and the sum of the last two dice \n        k = 2 * (j - 1) + 1\n        push!(c_idx, outcome[k] + outcome[k+1])\n        _idx = findfirst(x -> player.id ∈ x, game.columns[c_idx[j]])\n        # if the player does not have a piece in the column, start at position 1, otherwise put\n        # runner in the next position\n        idx = isnothing(_idx) ? 1 : _idx + 1\n        push!(r_idx, idx)\n    end\n    return c_idx, r_idx\nend","category":"page"},{"location":"basic_usage/#take_chance","page":"Basic Usage","title":"take_chance","text":"","category":"section"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"take_chance(game::AbstractGame, player::Player) = rand(Bool)\n","category":"page"},{"location":"basic_usage/#select_positions","page":"Basic Usage","title":"select_positions","text":"","category":"section"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"function select_positions(game::AbstractGame, player::Player, outcome)\n    # all possible columns\n    possible_cols = list_sums(game, outcome)\n    # activate columns containing a runner \n    c_idx, r_idx = get_runner_locations(game)\n    # possible columns which are also active \n    matching_cols = intersect(possible_cols, c_idx)\n    # get the first available active column index \n    m = findfirst(x -> x == matching_cols[1], c_idx)\n    return [c_idx[m],],[r_idx[m],]\nend","category":"page"},{"location":"basic_usage/#Run-Simulation","page":"Basic Usage","title":"Run Simulation","text":"","category":"section"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"game = Game()\n\nplayers = [Player(id=:p1), Player(id=:p2)]\n\n#simulate(game, players)","category":"page"},{"location":"#Overview","page":"Home","title":"Overview","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The purpose of this documentation is to describe the API for developing bots or models which play the board game Can't Stop. CantStop.jl provides two key features: (1) abstract types and methods which can be extended to implement bots with custom strategies, and (2) internal methods which can be extended to develop variations of Can't Stop.","category":"page"},{"location":"#Basic-Rules","page":"Home","title":"Basic Rules","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"In Can't Stop, the goal is to capture three columns. A column is capture by being the first to move a piece to the end of the column. As shown below, the board contains 11 columns labeled 2 through 12, which correspond to possible values for the sum of two six-sided dice. Sums corresponding to columns near the center have a higher probability, but also require more moves to capture. During a round, a player proceeds through two phases: a runner selection phase and a decision phase. During the runner selection phase, a player rolls 4 six sided dice two times. On the first roll, the player selects two pairs to decide which column to set two runners. If the player already has a piece in a given column, the runner can start in that position. Otherwise, the runner must start in the first position of the column. On the second roll, you select only additional runner, but you may move an existing runner by one row. ","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: image info)","category":"page"}]
}
