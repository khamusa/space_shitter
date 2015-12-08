require_relative 'lib/game'

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
    Game.new
  end

end

if __FILE__ == $0
  SpaceShooter.new.start
end
