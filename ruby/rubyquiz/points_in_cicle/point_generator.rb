# From http://rubyquiz.strd6.com/

Point = Struct.new(:x, :y) do
  def to_s
    "#<Point(#{x},#{y})>"
  end

  def self.random(x_bound, y_bound = nil)
    y_bound ||= x_bound

    x = (Kernel.rand * 2.0 * x_bound) - x_bound
    y = (Kernel.rand * 2.0 * y_bound) - y_bound

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
  def initialize(radius, origin = nil)
    @radius = radius.to_f
    @origin = origin || Point.new(0, 0)
  end

  # Generate a random {Point}
  # @param [Numeric] radius Radius of circle to use
  # @param [Point] origin {Point} in x/y coordinates to place circle
  def generate
    x = generate_random_x
    y = generate_random_y(x)

    Point.new(x + @origin.x, y + @origin.y)
  end

  # Find a random x to use.
  def generate_random_x
    max_x = @radius
    (Kernel.rand * 2.0 * max_x) - max_x
  end

  # Find a random y to use, given a random x.
  def generate_random_y(x)
    max_y = Math.sqrt(@radius**2 - x**2)
    (Kernel.rand * 2.0 * max_y) - max_y
  end
end
