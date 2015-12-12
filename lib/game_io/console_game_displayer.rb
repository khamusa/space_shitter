require 'curses'

class ConsoleGameDisplayer
  include Curses

  attr_accessor :world

  def initialize
    init_game_screen
    init_game_win
    init_menu_window
  end

  def game_tick
    @game_win.clear
    @game_win.box('|', '-')
    draw_objects(world.objects)

    @game_win.refresh

    draw_menu_win
    @menu_win.refresh
  end

  def world_width
    cols - 2
  end

  def world_height
    lines - 7
  end

  def say_bye(msg = "Bye bye!")
    bye = Window.new(
      5,
      msg.length + 8,
      lines / 2 - 5,
      cols / 2 - (msg.length + 4)
    )
    bye.setpos(2, 4)
    bye.addstr(msg)
    bye.box('|', '-')
    bye.refresh
    sleep(1)
  end

  private

  def init_game_screen
    init_screen
    nl
    noecho
    curs_set(0)
  end

  def init_game_win
    @game_win = Window.new(lines - 5, cols, 0, 0)
  end

  def init_menu_window
    @menu_win = Window.new(5, cols, lines - 5, 0)
  end

  def draw_menu_win
    @menu_win.box('|', '-')
    @menu_win.setpos(1, 1)
    @menu_win.addstr("The Spaceshitter Game")
    @menu_win.setpos(2, 1)
    @menu_win.addstr "World size is #{world_width}x#{world_height}"
  end

  def draw_objects(drawable_objects)
    drawable_objects.each do |object|
      object.char_map.each do |(offset_x, offset_y), chars|

        base_x = object.anchor_x  + offset_x
        base_y = object.anchor_y  + offset_y

        @game_win.setpos(base_y, base_x)
        @game_win.addstr(chars)
      end
    end
  end
end
