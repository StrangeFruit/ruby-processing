# Ported from http://processing.org/learning/topics/smokeparticlesystem.html
# For some reason this sketch needs to be run with the --nojruby flag
#
# A ParticleSystem (Array) object manages a variable size list of
# particles.

load_library :vecmath

attr_reader :ps, :img, :wind

def setup
  size(640,360)
  @img = load_image("texture.png")
  @ps = ParticleSystem.new(0, Vec2D.new(width/2, height - 60), img)
end

def draw
  background(0)  
  # Calculate a "wind" force based on mouse horizontal position
  dx = map(mouse_x, 0, width, -0.2, 0.2)
  @wind = Vec2D.new(dx, 0)
  ps.apply_force(wind)
  ps.run
  2.times do
    ps.add_particle
  end
  
  # Draw a horizontal arrow representing the wind force
  draw_vector(wind, Vec2D.new(width / 2, 50, 0), 500)
  
end

# Renders a vector object 'v' as an arrow and a location 'loc'
def draw_vector(v, loc, scayl)
  push_matrix
  # Translate to location to render vector
  translate(loc.x, loc.y)  
  rotate(v.heading)
  # Calculate length of vector & scale as necessary
  len = v.mag * scayl
  # Draw three lines to make an arrow 
  arrowsize = 4
  stroke(255)
  stroke_weight 2
  line(0, 0, len, 0)
  stroke_weight 1
  line(len, 0, len - arrowsize, +arrowsize/2)
  line(len, 0, len - arrowsize, -arrowsize/2)
  pop_matrix
end

module Runnable
  def run
    self.reject! { |item| item.lifespan <= 0 }
    self.each    { |item| item.run }
  end
end


class ParticleSystem 
  extend Enumerable
  include Runnable
  
  attr_reader :particles, :origin, :image, :generator
  
  def initialize(num, location, image)
    @particles = []
    @origin = location # no need for location.clone in ruby
    @image = image    
    (0 ... num).each do
      particles << Particle.new(origin, image)
    end
  end
  
  def each &block
    particles.each &block    
  end

  def reject! &block
    particles.reject! &block
  end
  
  def add_particle(p = Particle.new(origin, image))
    particles << p
  end
  
  # Method to add a force vector to all particles currently in the system
  def apply_force(dir) 
    self.each do |p|
      p.apply_force(dir)
    end  
  end 
end

# A simple Particle class

class Particle 
  include Processing::Proxy 
  
  attr_reader :loc, :acc, :vel, :lifespan, :img, :generator
  
  def initialize(l, img_) 
    @acc = Vec2D.new
    vx = random_gaussian * 0.3
    vy = random_gaussian * 0.3 - 1.0
    @vel = Vec2D.new(vx, vy)
    @loc = l # no need for l.clone in ruby
    @lifespan = 100.0
    @img = img_
  end
  
  def run
    update
    render
  end
  
  # Method to update location
  def update
    @vel += acc
    @loc += vel
    @lifespan -= 1.0
  end
  
  # Method to display
  def render 
    image_mode(CENTER)
    tint(255,lifespan)
    image(img, loc.x, loc.y)
  end
  
  # Method to add a force vector to all particles currently in the system
  def apply_force(f) 
    @acc += f
  end
  
end


