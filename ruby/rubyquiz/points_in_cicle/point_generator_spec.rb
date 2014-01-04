require 'rspec'
require_relative 'point_generator'

# Use the distance formula to find out whether or not we are in the right
# ballpark.
RSpec::Matchers.define :be_within_radius do |radius|
  match do |point|
    @radius = radius
    @origin ||= Point.new(0, 0)

    @distance = Math.sqrt((point.x - @origin.x)**2.0 + (point.y - @origin.y)**2.0)
    @distance <= @radius
  end

  chain :of_origin do |origin|
    @origin = origin
  end

  failure_message_for_should do |point|
    "#{point} was not within radius #{@radius} of origin #{@origin}. It was #{@distance} instead."
  end
end

describe Point do
  it "creates a new point" do
    point = Point.new(1, 2)
    expect(point).to be_kind_of(Point)
  end

  describe ".random" do
    it "creates a new Point" do
      point = Point.random(10)
      expect(point).to be_kind_of(Point)
    end
  end
end

describe PointGenerator do
  let(:radius) { 6 }

  it "creates a new generator" do
    generator = PointGenerator.new(radius)
  end

  describe "generate" do
    it "creates a point within x and y bounds" do
      generator = PointGenerator.new(radius)

      1000.times do
        point = generator.generate
        expect(point).to be_within_radius(radius)
      end
    end

    it "respects the origin" do
      bound = 100.0

      1000.times do
        origin = Point.random(100)
        generator = PointGenerator.new(radius, origin)
        point = generator.generate

        expect(point).to be_within_radius(radius).of_origin(origin)
      end
    end
  end
end
