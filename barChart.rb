require 'rubyvis'
require_relative 'analysis'

#data = pv.range(10).map {|d| rand + 0.1 }

data = Array.new 
array = Array.new

@visualize.each do |key,value|
    array << key 
    data << value 
end

#data = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]
#array = ["ABC","DEF","MKL"] 
#/* Sizing and scales. *
w = 500 
h = 400 
x = pv.Scale.linear(0, 1.1).range(0, w)
y = pv.Scale.ordinal(pv.range(10)).split_banded(0, h, 4/5.0)

#/* The root panel. */
vis = pv.Panel.new()
    .width(w)
    .height(h)
    .bottom(20)
    .left(200)
    .right(30)
    .top(10);

#/* The bars. */
bar = vis.add(pv.Bar)
    .data(data)
    .top(lambda { y.scale(self.index)})
    .height(y.range_band)
    .left(0)
    .width(x)

#/* The value label. */
bar.anchor("right").add(pv.Label)
    .text_style("white")
    .text(lambda {|d| "%0.1f" % d})

#/* The variable label. */
bar.anchor("left").add(pv.Label)
    .text_margin(5)
    .text_align("right")
    .text(lambda { array[self.index,1]});
 
#/* X-axis ticks. */
vis.add(pv.Rule)
    .data(x.ticks(5))
    .left(x)
    .stroke_style(lambda {|d|  d!=0 ? "rgba(255,255,255,.3)" : "#000"})
  .add(pv.Rule)
    .bottom(0)
    .height(5)
    .stroke_style("#000")
  .anchor("bottom").add(pv.Label)
  .text(x.tick_format);

vis.render();
puts vis.to_svg
data.clear
array.clear
