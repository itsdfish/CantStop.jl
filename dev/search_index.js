var documenterSearchIndex = {"docs":
[{"location":"api/#Required","page":"API","title":"Required","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"The API requires you to create a subtype of AbstractPlayer with extensions of the methods below.","category":"page"},{"location":"api/#Types","page":"API","title":"Types","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"AbstractPlayer","category":"page"},{"location":"api/#CantStop.AbstractPlayer","page":"API","title":"CantStop.AbstractPlayer","text":"AbstractPlayer\n\nAn abstract type for a player. Subtypes of AbstractPlayer must have the fields described below.\n\nFields\n\nid::Symbol: player id\npieces::Vector{Symbol}: a vector of 11 pieces where each piece has the value id. \npiece_reserve::Vector{Symbol}: an optional vector for keeping track of pieces which will replace runners unless a bust occurs\n\nIn addition, for a subtype MyPlayer <: AbstractPlayer, the API requires the following constructor to ensure  the correct number of pieces are provided. \n\nConstructor\n\nMyPlayer(;id, pieces=fill(id, 11)) = MyPlayer(id, pieces)\n\n\n\n\n\n","category":"type"},{"location":"api/#Methods","page":"API","title":"Methods","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"take_chance\nselect_positions\npostbust_cleanup!\npoststop_cleanup!","category":"page"},{"location":"api/#CantStop.take_chance","page":"API","title":"CantStop.take_chance","text":"take_chance(Game::AbstractGame, player::AbstractPlayer)\n\nDuring the decision phase, decide whether to take a chance to advance the runners, or set your pieces in  the current location of the runners. \n\nArguments\n\nGame::AbstractGame: an abstract game \nplayer::AbstractPlayer: an subtype of a abstract player\n\nReturns\n\ndecision::Bool: true if take chance, false otherwise\n\n\n\n\n\n","category":"function"},{"location":"api/#CantStop.select_positions","page":"API","title":"CantStop.select_positions","text":"select_positions(Game::AbstractGame, player::AbstractPlayer, options)\n\nDuring the selection phase, select runners based on the outcome of a dice roll. \n\nArguments\n\nGame::AbstractGame: an abstract game \nplayer::AbstractPlayer: an subtype of a abstract player\noptions: a vector of columns that can be selected based on outcome of rolling dice\n\nReturns\n\nc_idx::Vector{Int}: a vector of selected column indices for moving runner\n\n\n\n\n\n","category":"function"},{"location":"api/#CantStop.postbust_cleanup!","page":"API","title":"CantStop.postbust_cleanup!","text":"postbust_cleanup!(Game::AbstractGame, player::AbstractPlayer)\n\nPerforms cleanup and book keeping after a \"bust\" (i.e., a roll that does not provide a valid move).\n\nArguments\n\nGame::AbstractGame: an abstract game \nplayer::AbstractPlayer: an subtype of a abstract player\n\nReturns\n\nnothing\n\n\n\n\n\n","category":"function"},{"location":"api/#CantStop.poststop_cleanup!","page":"API","title":"CantStop.poststop_cleanup!","text":"poststop_cleanup!(Game::AbstractGame, player::AbstractPlayer)\n\nPerforms cleanup and book keeping after deciding to stop rolling during the decision phase.\n\nArguments\n\nGame::AbstractGame: an abstract game \nplayer::AbstractPlayer: an subtype of a abstract player\n\nReturns\n\nnothing\n\n\n\n\n\n","category":"function"},{"location":"api/#Optional-Types","page":"API","title":"Optional Types","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"It is possible to create variations of the game by creating a new subtype of AbstractGame and  defining new internal methods as needed. ","category":"page"},{"location":"api/","page":"API","title":"API","text":"AbstractGame","category":"page"},{"location":"api/#CantStop.AbstractGame","page":"API","title":"CantStop.AbstractGame","text":"AbstractGame\n\nAn abstract game type for Can't Stop. \n\nThe following fields are required in order to work with default methods: \n\nFields\n\ndice::Dice: an object resepresenting four dice \npieces::Dict{Symbol,Vector{Symbol}}: inactive pieces for each player: player_id -> pieces\ncolumns_won::Vector{Int}: a vector of indices for columns won\nmax_rows::Dict{Int,Int}: maximum number of rows for each column\nplayers_won::Dict{Int,Symbol}: indicates which player won a given column. A value of :_ indicates no    player has won the column\n\n\n\n\n\n","category":"type"},{"location":"api/#Available-Types","page":"API","title":"Available Types","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"Game","category":"page"},{"location":"api/#CantStop.Game","page":"API","title":"CantStop.Game","text":"Game{P<:AbstractPiece} <: AbstractGame\n\nThe default game object for CantStop. \n\nFields\n\ndice::Dice: an object resepresenting four dice \npieces::Dict{Symbol,Vector{Symbol}}: inactive pieces for each player: player_id -> pieces\ncolumns_won::Vector{Int}: a vector of indices for columns won\nmax_rows::Dict{Int,Int}: maximum number of rows for each column\nplayers_won::Dict{Int,Symbol}: indicates which player won a given column. A value of :_ indicates no    player has won the column\n\nConstructor\n\nGame(;dice=Dice(), piece_type=Piece)\n\n\n\n\n\n","category":"type"},{"location":"api/#Utilities","page":"API","title":"Utilities","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"The following methods might be helpful for defining the required methods above.","category":"page"},{"location":"api/","page":"API","title":"API","text":"simulate","category":"page"},{"location":"api/#CantStop.simulate","page":"API","title":"CantStop.simulate","text":"simulate(game::AbstractGame, players)\n\nSimulate CantStop until a player has won. \n\nArguments\n\ngame::AbstractGame: an abstract game object for Can't Stop\nplayer::AbstractPlayer: an subtype of a abstract player\n\n\n\n\n\n","category":"function"},{"location":"internal_methods/","page":"Internal Methods","title":"Internal Methods","text":"Modules = [CantStop]\nOrder   = [:type, :function]\nPublic = false","category":"page"},{"location":"internal_methods/#CantStop.Dice","page":"Internal Methods","title":"CantStop.Dice","text":"Dice\n\nAn object for rolling dice. \n\nFields\n\nn::Int: number of rolls \nsides::Int: number of sides per die\n\nConstructors\n\nDice(4, 6)\nDice(;n=4, sides=6)\n\n\n\n\n\n","category":"type"},{"location":"internal_methods/#CantStop.decision_phase!-Tuple{AbstractGame, AbstractPlayer}","page":"Internal Methods","title":"CantStop.decision_phase!","text":"decision_phase!(game::AbstractGame, player::AbstractPlayer)\n\nImplements the decision phase in which the player decides to roll the dice for the possibility of  moving the runners. The two methods named decide! are called during this phase.\n\nArguments\n\ngame::AbstractGame: an abstract game object for Can't Stop\nplayer::AbstractPlayer: an subtype of a abstract player\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.handle_bust!-Tuple{AbstractGame, AbstractPlayer}","page":"Internal Methods","title":"CantStop.handle_bust!","text":"set_runners_false!(game::AbstractGame, player)\n\nArguments\n\ngame::AbstractGame: an abstract game object for Can't Stop\nplayer::AbstractPlayer: an subtype of a abstract player\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.handle_stop!-Tuple{AbstractGame, AbstractPlayer}","page":"Internal Methods","title":"CantStop.handle_stop!","text":"set_runners_false!(game::AbstractGame, player)\n\nArguments\n\ngame::AbstractGame: an abstract game object for Can't Stop\nplayer::AbstractPlayer: an subtype of a abstract player\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.initialize_pieces!-Tuple{AbstractGame, AbstractPlayer}","page":"Internal Methods","title":"CantStop.initialize_pieces!","text":"set_runners_false!(game::AbstractGame, player)\n\nArguments\n\ngame::AbstractGame: an abstract game object for Can't Stop\nplayer::AbstractPlayer: an subtype of a abstract player\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.is_bust-Tuple{AbstractGame, Any}","page":"Internal Methods","title":"CantStop.is_bust","text":"is_bust(game::AbstractGame, options)\n\nChecks whether a dice roll is a bust i.e., does not allow a valid move. \n\nArguments\n\ngame::AbstractGame: an abstract game object for Can't Stop\noptions: a vector of column indices corresponding to possible choices\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.is_playing-Tuple{AbstractGame}","page":"Internal Methods","title":"CantStop.is_playing","text":"is_playing(game::AbstractGame)\n\nArguments\n\ngame::AbstractGame: an abstract game object for Can't Stop\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.list_options-Tuple{Any, Any}","page":"Internal Methods","title":"CantStop.list_options","text":"list_sums(outcome)\n\nLists all unique sum of combinations of the outcome of rolling dice\n\nArguments\n\ngame::AbstractGame: an abstract game object for Can't Stop\noutcome: the results of rolling the dice\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.list_sums-Tuple{Any}","page":"Internal Methods","title":"CantStop.list_sums","text":"list_sums(outcome)\n\nLists all unique sum of combinations of the outcome of rolling dice\n\nArguments\n\noutcome: the results of rolling the dice\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.move!-Tuple{AbstractGame, Any, Any}","page":"Internal Methods","title":"CantStop.move!","text":"move!(game::AbstractGame, id, r_idx)\n\nMove runner to location determined by column and row index\n\nArguments\n\ngame::AbstractGame: an abstract game object\nid: the id of the player \nc_idx: column index of position \n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.play_round!-Tuple{AbstractGame, AbstractPlayer}","page":"Internal Methods","title":"CantStop.play_round!","text":"play_round!(game::AbstractGame, player::AbstractPlayer)\n\nPlay one round with a specified player. During each iteration of a round, the player makes two decision_phase\n\ndecide whether to roll the dice\ndecide which dice to pair and sum to select columns\n\nArguments\n\ngame::AbstractGame: an abstract game object for Can't Stop\nplayer::AbstractPlayer: an subtype of a abstract player\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.return_to_start_position!-Tuple{AbstractGame, AbstractPlayer}","page":"Internal Methods","title":"CantStop.return_to_start_position!","text":"return_to_start_position!(game::AbstractGame, player::AbstractPlayer)\n\nArguments\n\ngame::AbstractGame: an abstract game object for Can't Stop\nplayer::AbstractPlayer: an subtype of a abstract player\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.set_runners_false!-Tuple{AbstractGame, AbstractPlayer}","page":"Internal Methods","title":"CantStop.set_runners_false!","text":"set_runners_false!(game::AbstractGame, player)\n\nArguments\n\ngame::AbstractGame: an abstract game object for Can't Stop\nplayer::AbstractPlayer: an subtype of a abstract player\n\n\n\n\n\n","category":"method"},{"location":"internal_methods/#CantStop.set_status!-Tuple{AbstractGame, Any, Any}","page":"Internal Methods","title":"CantStop.set_status!","text":"set_status!(game::AbstractGame, id, c_idx)\n\nMove runner to location determined by column and row index\n\nArguments\n\ngame::AbstractGame: an abstract game object\nid: the id of the player \nc_idx: column index of position \n\n\n\n\n\n","category":"method"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"using CantStop\nimport CantStop: postbust_cleanup!\nimport CantStop: poststop_cleanup!\nimport CantStop: select_runners\nimport CantStop: select_positions\nimport CantStop: take_chance","category":"page"},{"location":"basic_usage/#Introduction","page":"Basic Usage","title":"Introduction","text":"","category":"section"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"In this tutorial, we provide a basic example to illustrate how to use the API for Cantstop.jl.","category":"page"},{"location":"basic_usage/#Example","page":"Basic Usage","title":"Example","text":"","category":"section"},{"location":"basic_usage/#Dependencies","page":"Basic Usage","title":"Dependencies","text":"","category":"section"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"The first step is to load the dependencies. In this simple example, the only dependency we need is CantStop, which is loaded via the using keyword. In addition, we must import a total of five methods using the keyword import. By importing the methods, we can define a version of each method which works with our player type. ","category":"page"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"using CantStop\nimport CantStop: postbust_cleanup!\nimport CantStop: poststop_cleanup!\nimport CantStop: select_runners\nimport CantStop: select_positions\nimport CantStop: take_chance","category":"page"},{"location":"basic_usage/#Make-Player-Type","page":"Basic Usage","title":"Make Player Type","text":"","category":"section"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"The API for CantStop requires you to define your own player type, which is a subtype of AbstractPlayer. The example below contains three required fields: id, which is a unique identifier for an instance of your player type, pieces, which is a vector containing 11 elements of id, and piece_reserve, which contain","category":"page"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"struct Player <: AbstractPlayer\n    id::Symbol\n    pieces::Vector{Symbol}\n    piece_reserve::Vector{Symbol}\nend\n\nPlayer(;id) = Player(id, fill(id, 11), Symbol[])","category":"page"},{"location":"basic_usage/#Required-Methods","page":"Basic Usage","title":"Required Methods","text":"","category":"section"},{"location":"basic_usage/#select_runners","page":"Basic Usage","title":"select_runners","text":"","category":"section"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"function select_runners(game::AbstractGame, player::Player, outcome, i)\n    c_idx = Int[]\n    r_idx = Int[]\n    # on first attempt, 2 positions are given, but only 1 position on the second attempt\n    for j ∈ 1:(3 - i)\n        # columns are the sum of the first two dice and the sum of the last two dice \n        k = 2 * (j - 1) + 1\n        push!(c_idx, outcome[k] + outcome[k+1])\n        _idx = findfirst(x -> player.id ∈ x, game.columns[c_idx[j]])\n        # if the player does not have a piece in the column, start at position 1, otherwise put\n        # runner in the next position\n        idx = isnothing(_idx) ? 1 : _idx + 1\n        push!(r_idx, idx)\n    end\n    return c_idx, r_idx\nend","category":"page"},{"location":"basic_usage/#take_chance","page":"Basic Usage","title":"take_chance","text":"","category":"section"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"take_chance(game::AbstractGame, player::Player) = rand(Bool)\n","category":"page"},{"location":"basic_usage/#select_positions","page":"Basic Usage","title":"select_positions","text":"","category":"section"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"function select_positions(game::AbstractGame, player::Player, outcome)\n    # all possible columns\n    possible_cols = list_sums(game, outcome)\n    # activate columns containing a runner \n    c_idx, r_idx = get_runner_locations(game)\n    # possible columns which are also active \n    matching_cols = intersect(possible_cols, c_idx)\n    # get the first available active column index \n    m = findfirst(x -> x == matching_cols[1], c_idx)\n    return [c_idx[m],],[r_idx[m],]\nend","category":"page"},{"location":"basic_usage/#Run-Simulation","page":"Basic Usage","title":"Run Simulation","text":"","category":"section"},{"location":"basic_usage/","page":"Basic Usage","title":"Basic Usage","text":"game = Game()\n\nplayers = [Player(id=:p1), Player(id=:p2)]\n\n#simulate(game, players)","category":"page"},{"location":"#Overview","page":"Home","title":"Overview","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The purpose of this documentation is to describe the API for developing bots or models which play the board game Can't Stop. CantStop.jl provides two key features: (1) abstract types and methods which can be extended to implement bots with custom strategies, and (2) internal methods which can be extended to develop variations of Can't Stop.","category":"page"},{"location":"#Basic-Rules","page":"Home","title":"Basic Rules","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"In Can't Stop, the goal is to capture three columns. A column is capture by being the first to move a piece to the end of the column. As shown below, the board contains 11 columns labeled 2 through 12, which correspond to possible values for the sum of two six-sided dice. Sums corresponding to columns near the center have a higher probability, but also require more moves to capture. During a round, a player proceeds through two phases: a runner selection phase and a decision phase. During the runner selection phase, a player rolls 4 six sided dice two times. On the first roll, the player selects two pairs to decide which column to set two runners. If the player already has a piece in a given column, the runner can start in that position. Otherwise, the runner must start in the first position of the column. On the second roll, you select only additional runner, but you may move an existing runner by one row. ","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: image info)","category":"page"}]
}
