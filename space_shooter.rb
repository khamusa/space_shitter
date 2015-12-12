require_relative 'lib/game'
require_relative 'lib/console_game_displayer'
require_relative 'lib/keyboard_input_handler'

class SpaceShooter
  attr_reader :game

  def initialize
    @game = create_game
  end

  def start
    @game.start
  end

  private

  def create_game
    Game.new(
      displayer: ConsoleGameDisplayer.new,
      input_handler: KeyboardInputHandler.new
    )
  end

end

if __FILE__ == $0
  SpaceShooter.new.start
end
