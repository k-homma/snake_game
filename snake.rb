#!/usr/bin/env ruby
# coding: utf-8

require 'curses'
include Curses

class Sna
 attr_accessor :pause
  def initialize
    @win = Window.new(lines, cols, 0, 0)
    @pos_x =[1]
    @pos_y =[1]
    @dir = :right
    @snake = 0
    @gamespeed = 0.07
    #i =0
    #k=0
  end


  def set_win
    @win.setpos(@food_y,@food_x)
    @win.addstr("*")
    @win.setpos(0,cols-19)
    @win.addstr("Body length: " + @snake.to_s)
    # @win.setpos(@pos_y[0],@pos_x[0])
    # @win.addstr("s")
    @win.setpos(1, 0)
    @win.addstr("Snake game")
  end

  def mfood(a, b)
    # @food_y = rand(1..a+2)
    # @food_x = rand(1..b+2)
    @food_y = rand(2..a-2)
    @food_x = rand(1..b-2)
   # a=2*a
   # b+=1
  end

  # def mfood2(m,n)
  #   @food2_y = rand(2..m-2)
  #   @food2_x = rand(1..n-2)
  #   setpos(@food2_y,@food2_x)
  #   addstr(")
  # end

  def dir
    c=getch
    case c
    when ?Q, ?q
      exit
    when KEY_UP, ?j
      @dir = :up if @dir != :down
    when KEY_DOWN, ?k
      @dir = :down if @dir != :up
    when KEY_LEFT, ?h
      @dir = :left if @dir != :right
    when KEY_RIGHT, ?l
      @dir = :right if @dir != :left
    end
  end

  def dir2
    case @dir
    when :up then @pos_y[0] -= 1
    when :down then @pos_y[0] += 1
    when :left then @pos_x[0] -= 1
    when :right then @pos_x[0] += 1
    end
  end

  def sipo
    t = @snake + 1
    while t > 0 do
      @pos_x[t] = @pos_x[t-1]
      @pos_y[t] = @pos_y[t-1]
      t -= 1
    end
    #setpos(@pos_y[t],@pos_x[t])
    #addstr(")

    for t in 0..@snake+1
      setpos(@pos_y[t],@pos_x[t])
      t == 1
      addstr("0")
      setpos(0,0)
    end
  end
  
  def speed
    sleep( ( @dir == :left or @dir == :right ) ? @gamespeed/2 : @gamespeed )
  end

  
  def owari
    if @pos_y[0] == lines-1 || @pos_y[0] ==0 || @pos_x[0] == cols-1 || @pos_x[0] == 0
      # @win.setpos(2, 0)
      # @win.addstr("game over")
      # refresh
      sleep(1)
      exit
    end
    
    for i in 2..@snake
      if @pos_y[0] == @pos_y[i] and @pos_x[0] == @pos_x[i]
        # @win.setpos(2, 0)
        # @win.addstr("game over")
        sleep(1)
        exit
      end
    end
  end
  
  def esa_tabe
    if @pos_y[0] == @food_y and @pos_x[0] == @food_x
      mfood(lines,cols)
      @snake += 1
    end
  end
  
  #  def esa2_tabe
  #   if @pos_y[0] == @food2_y and @pos_x[0] == @food2_x
  #    mfood2(lines,cols)
  #   @snake += 5
  # end
  # end
  
  # if @snake == 10
  #   mfood2
  #   esa2_tabe
  # end

  def refresh
    @win.refresh
    @win.clear
  end
end



def pause
  @sna.dir
  if @sna.pause
    sleep(1)
    pause
  end
end

print"- - - - - - - - \n"
print"snake game.\n"
print"Start Enter key or any key\n"
print"quit = q\n"
print"- - - - - - - - \n"

d=STDIN.gets.chomp!

if d == "q"
  exit
end
#sleep(2)


noecho
Curses.timeout = 0
stdscr.keypad=true
@sna = Sna.new
@sna.mfood(lines, cols)

begin
  loop do
    pause
    @sna.set_win
    @sna.dir2
    @sna.sipo
    @sna.speed
    @sna.owari
    @sna.esa_tabe
    # if @snake == 2
    #  @sna.mfood2
    #  @sna.esa2_tabe
    # end
    # @sna.k
    @sna.refresh
    refresh
  end
ensure
  close_screen
end
