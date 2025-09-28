require 'gosu'

class DoodleJumpStyleGame < Gosu::Window
  def initialize
    super(400, 600)
    self.caption = "Doodle Jump Style Game"
    @player_x, @player_y = 180, 500
    @vy = 0
    @platforms = Array.new(8){[rand(0..350), rand(0..550)]}
    @score = 0
    @font = Gosu::Font.new(24)
  end

  def update
    @vy += 0.5
    @player_y += @vy
    @player_x += (-5 if Gosu.button_down? Gosu::KB_LEFT).to_i
    @player_x += (5 if Gosu.button_down? Gosu::KB_RIGHT).to_i
    @player_x %= 400
    if @player_y > 590
      @player_y, @vy, @score = 500, 0, 0
    end
    @platforms.each do |p|
      if @player_x+32>p[0] && @player_x<p[0]+60 && @player_y+32>p[1] && @player_y+32< p[1]+12 && @vy>0
        @vy = -12
        @score += 1
      end
    end
    if @player_y < 200
      @player_y = 200
      @platforms.map! do |p|
        [p[0], p[1]+@vy.abs]
      end
      @platforms.each do |p|
        if p[1]>600
          p[0]=rand(0..350); p[1]=0
        end
      end
    end
  end

  def draw
    Gosu.draw_rect(@player_x, @player_y, 32, 32, Gosu::Color::YELLOW)
    @platforms.each { |p| Gosu.draw_rect(p[0], p[1], 60, 12, Gosu::Color::GREEN) }
    @font.draw_text("Score: #{@score}", 10, 10, 0, 1, 1, Gosu::Color::WHITE)
  end
end

DoodleJumpStyleGame.new.show