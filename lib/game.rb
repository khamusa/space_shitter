require_relative 'world'
require_relative 'enemy'
require_relative 'space_ship'
require_relative 'console_game_displayer'
require_relative 'keyboard_input_handler'


class Game
  attr_reader :world, :displayer

  SPACESHIP_CHAR_MAP = {
    [-2, -1] => "--\\",
    [-1, 0] => ">===>",
    [-2, 1] => "--/"
  }

  def initialize opts = {}
    @displayer        = opts.fetch(:displayer, default_displayer)
    @world            = opts.fetch(:world, default_world)
    @displayer.world  = @world
    @input_handler    = opts.fetch(:input_handler, default_input_handler)
    @player_spaceship = default_spaceship
    @an_enemy         = Enemy.new(80, @player_spaceship.anchor_y)
    @world.objects    = [ @player_spaceship, @an_enemy ]
  end

  def start
    begin
      main_loop
    rescue Interrupt => e
      @displayer.say_bye
    end
  end

  private

  def main_loop
    loop do
      displayer.game_tick
      world.game_tick
      process_user_action
      sleep(0.01)
    end
  end

  private

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

  def default_displayer
    @displayer = ConsoleGameDisplayer.new
  end

  def default_spaceship
    SpaceShip.new(
      (@world.width * (10.0/100)).ceil,  # Starting position relative to world size
      (@world.height * (50.0/100)).ceil,
      SPACESHIP_CHAR_MAP
    )
  end

  def default_input_handler
    KeyboardInputHandler.new
  end


end
