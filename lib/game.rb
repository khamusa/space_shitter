require_relative 'world'
require_relative 'world_objects/enemy'
require_relative 'world_objects/space_ship'

class Game
  attr_reader :world, :displayer

  SPACESHIP_CHAR_MAP = {
    [-2, -1] => "--\\",
    [-1, 0] => ">===>",
    [-2, 1] => "--/"
  }

  def initialize opts = {}
    @displayer        = opts.fetch(:displayer)
    @input_handler    = opts.fetch(:input_handler)
    @world            = opts.fetch(:world, default_world)
    @displayer.world  = @world
    @player_spaceship = default_spaceship
    test_enemy = Enemy.new(
      @world.width - 10,
      20,
      char_map: { [ 0, 0 ] => "<===>"},
      hor_speed: -10
    )
    @world.register_objects( [ @player_spaceship, test_enemy ] )
  end

  def start
    begin
      loop { main_loop }
    rescue Interrupt => e
      @displayer.say_bye
    end
  end

  private

  def main_loop
    displayer.game_tick
    world.game_tick
    process_user_action
    sleep(0.007)
  end

  def process_user_action
    case @input_handler.get_player_action
    when :left
      @player_spaceship.move(-2, 0)
    when :right
      @player_spaceship.move(2, 0)
    when :up
      @player_spaceship.move(0, -1)
    when :down
      @player_spaceship.move(0, 1)
    when :fire
      @world.register_objects(
        @player_spaceship.fire!
      )
    end
  end

  def default_world
    World.new(displayer.world_width, displayer.world_height)
  end

  def default_spaceship
    SpaceShip.new(
      (@world.width * (10.0/100)).ceil,  # Starting position relative to world size
      (@world.height * (50.0/100)).ceil,
      char_map: SPACESHIP_CHAR_MAP
    )
  end
end
