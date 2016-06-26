require 'curses'
require 'set'

class KeyboardInputHandler
  # this is our code though

  def initialize
    Curses.timeout = 0
    Curses.stdscr.keypad = true
  end

  def get_player_actions
    actions = Set.new

    while (char = Curses.getch) != nil
      actions.add action_from_key char
    end

    actions
  end

  private

  def action_from_key(key)
    case key
      when Curses::Key::LEFT
        :left
      when Curses::Key::DOWN
        :down
      when Curses::Key::UP
        :up
      when Curses::Key::RIGHT
        :right
      when ' '
        :fire
      else
        nil
    end
  end
end
