# From http://rubyquiz.strd6.com/

# Helper module for random ranges.
module RandomRange
  # Helper method to generate numbers between <tt>lower</tt> and
  # <tt>upper</tt>.
  #
  # @param [Numeric] lower
  # @param [Numeric] upper
  # @return [Numeric]
  def random_range(lower, upper)
    Kernel.rand * (upper - lower) + lower
  end
end

# Point class to use for convenience.
Point = Struct.new(:x, :y) do
  extend RandomRange

  # For pretty printing
  # @return [String]
  def to_s
    "#<Point(#{x},#{y})>"
  end

  # Create a random point.
  #
  # @param [Numeric] x_bound Place x within +/- x_bound
  # @param [Numeric] y_bound Place y within +/- y_bound
  # @return [Point]
  def self.random(x_bound, y_bound = nil)
    y_bound ||= x_bound

    x = random_range(-x_bound, x_bound)
    y = random_range(-y_bound, y_bound)

    new(x, y)
  end
end

# Generates points within a circle by calling the <tt>generate</tt> method.
#
# Reference formula for a circle:
# r^2 = x^2 + y^2
#     or in terms of y:
# y = +/- (r^2 - x^2)^(1/2)
class PointGenerator
  include RandomRange

  def initialize(radius, origin = nil)
    @radius = radius.to_f
    @origin = origin || Point.new(0, 0)
  end

  # Generate a random {Point}
  # @param [Numeric] radius Radius of circle to use
  # @param [Point] origin {Point} in x/y coordinates to place circle
  # @return [Point]
  def generate
    x = generate_random_x
    y = generate_random_y(x)

    Point.new(x + @origin.x, y + @origin.y)
  end

  # Find a random x to use.
  # @return [Float]
  def generate_random_x
    max_x = @radius
    random_range(-max_x, max_x)
  end
  private :generate_random_x

  # Find a random y to use, given a random x.
  # @param [Numeric] x
  # @return [Float]
  def generate_random_y(x)
    max_y = Math.sqrt(@radius**2 - x**2)
    random_range(-max_y, max_y)
  end
  private :generate_random_y
end
