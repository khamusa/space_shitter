require 'curses'
class KeyboardInputHandler
  # this is our code though

  def initialize
    Curses.timeout = 0
    Curses.stdscr.keypad = true
  end

  def get_player_action
    action_from_key(Curses.getch)
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
