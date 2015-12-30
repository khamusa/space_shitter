#!/usr/local/bin/ruby
# rain for a curses test

require "curses"
include Curses

def onsig(sig)
  close_screen
  exit sig
end

def ranf
  rand(32767).to_f / 32767
end

# main #
for i in %w[HUP INT QUIT TERM]
  if trap(i, "SIG_IGN") != 0 then  # 0 for SIG_IGN
    trap(i) {|sig| onsig(sig) }
  end
end

init_screen
nl
noecho
srand

xpos = {}
ypos = {}
r = lines - 4
c = cols - 4

for i in 0 .. 4
  xpos[i] = (c * ranf).to_i + 2
  ypos[i] = (r * ranf).to_i + 2
end

i = 0
while TRUE
  x = (c * ranf).to_i + 2
  y = (r * ranf).to_i + 2

  setpos(y, x); addstr(".")

  setpos(ypos[i], xpos[i]); addstr("o")

  i = if i == 0 then 4 else i - 1 end
  setpos(ypos[i], xpos[i]); addstr("O")

  i = if i == 0 then 4 else i - 1 end
  setpos(ypos[i] - 1, xpos[i]);      addstr("-")
  setpos(ypos[i],     xpos[i] - 1); addstr("|.|")
  setpos(ypos[i] + 1, xpos[i]);      addstr("-")

  i = if i == 0 then 4 else i - 1 end
  setpos(ypos[i] - 2, xpos[i]);       addstr("-")
  setpos(ypos[i] - 1, xpos[i] - 1);  addstr("/ \\")
  setpos(ypos[i],     xpos[i] - 2); addstr("| O |")
  setpos(ypos[i] + 1, xpos[i] - 1); addstr("\\ /")
  setpos(ypos[i] + 2, xpos[i]);       addstr("-")

  i = if i == 0 then 4 else i - 1 end
  setpos(ypos[i] - 2, xpos[i]);       addstr(" ")
  setpos(ypos[i] - 1, xpos[i] - 1);  addstr("   ")
  setpos(ypos[i],     xpos[i] - 2); addstr("     ")
  setpos(ypos[i] + 1, xpos[i] - 1);  addstr("   ")
  setpos(ypos[i] + 2, xpos[i]);       addstr(" ")

  xpos[i] = x
  ypos[i] = y
  refresh
  sleep(0.5)
end

# end of main
if false
require 'tty-screen'

puts screen = TTY::Screen.new
puts screen.size     # => [51, 280]
puts screen.width    # => 280
puts screen.height   # => 51

require 'tty-cursor'

cursor = TTY::Cursor

print "hahahahha"
print "\n Second line"
sleep(2)
print "\r"
print "\r"
print "\r"
print "saaaaaaaaaaaaaammmmmmmmmmmhahaha"

print cursor.clear_lines(4, :up)
cursor.clear_line
cursor.clear_line
end
