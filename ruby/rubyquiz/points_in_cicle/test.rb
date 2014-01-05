require_relative 'point_generator'

points    = []
generator = PointGenerator.new(21, Point.new(10, 0))

100.times do
  points << generator.generate
end

svg = <<ENDSVG
<svg xmlns="http://www.w3.org/2000/svg" viewBox="-100 -100 200 200">

#{points.map{ |point| "<circle cx='#{point.x}' cy='#{point.y}' r='1' />" }.join("\n")}

  <line x1="-5" y1="-20" x2="5" y2="-20" style="stroke:rgb(255,0,0);stroke-width:1" />
  <line x1="-5" y1="20" x2="5" y2="20" style="stroke:rgb(255,0,0);stroke-width:1" />
  <line y1="-5" x1="-20" y2="5" x2="-20" style="stroke:rgb(255,0,0);stroke-width:1" />
  <line y1="-5" x1="20" y2="5" x2="20" style="stroke:rgb(255,0,0);stroke-width:1" />

  <line x1="-100" y1="0" x2="100" y2="0" style="stroke:rgb(255,0,0);stroke-width:1" />
  <line x1="0" y1="-100" x2="0" y2="100" style="stroke:rgb(255,0,0);stroke-width:1" />
</svg>
ENDSVG

File.open('test.svg', 'w') { |f| f.write svg }
