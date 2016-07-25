# Ruby Chess

![screenshot](/media/sc.png "sc.png")

Ruby Chess is a ruby implementation of a command-line chess game. It was written under the best practices of OOP to keep the code DRY and robust, complete with unit and integration tests. It also implements the cursorable module from rglassett's [ruby-cursor-game](https://github.com/rglassett/ruby-cursor-game).

To start playing:
* Clone the repository
```bash
git clone https://github.com/fonsecapeter/ruby_chess
```
* Install dependencies
```bash
bundle install
```
* Run the game
```bash
ruby ruby_chess/game.rb
```
 > This will default to playing against the computer. If you would like to play with a friend, just run `ruby ruby_chess/game.rb 2`. You can specify 0-2 players in this way (0 being a match between two computer players).

### Cool Features

* The computer player will prioritize moves based on putting the opponent in checkmate, check, or attacking the most valuable pieces possible.

```ruby
def pick_valuable_move
  # reset @valid_moves
  get_valid_moves

  # only process best outcomes
  if can_checkmate?
    return checkmates.sample
  elsif can_check?
    return checks.sample
  elsif can_attack?
    return attacks.first
  else
    return @valid_moves.sample
  end
end
```

 * Pawn promotion

 ![pawn_promotion](/media/pawn_promotion.gif "pawn_promotion.gif")


 ### Future Plans

 * Poly-Tree-based AI consideration of future moves
 * Yml-based game state saving
 * Color preferences
