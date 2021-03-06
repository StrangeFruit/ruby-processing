# The current time can be read with the second(), minute(), 
# and hour() functions. In this example, sin() and cos() values
# are used to set the position of the hands.


def setup
  size 200, 200
  stroke 255
  smooth
end

def draw
  background 0
  fill 80
  no_stroke
  
  # Angles for sin() and cos() start at 3 o'clock;
  # subtract HALF_PI to make them start at the top
  ellipse 100, 100, 160, 160
  
  s = map( second, 0, 60, 0, TWO_PI) - HALF_PI
  m = map( minute + norm( second, 0, 60 ), 0, 60, 0, TWO_PI ) - HALF_PI
  h = map( hour + norm( minute, 0, 60 ), 0, 24, 0, TWO_PI * 2 ) - HALF_PI
  
  stroke 255
  stroke_weight 1
  line( 100, 100, cos(s)*72 + 100, sin(s)*72 + 100 )
  stroke_weight 2
  line( 100, 100, cos(m)*60 + 100, sin(m)*60 + 100 )
  stroke_weight 4
  line( 100, 100, cos(h)*50 + 100, sin(h)*50 + 100 )
  
  # Draw the minute ticks
  stroke_weight 2
  (0..360).step(6) do |a|
    x = 100 + cos( a.radians ) * 72
    y = 100 + sin( a.radians ) * 72
    point x, y
  end
end
