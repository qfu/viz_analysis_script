require 'rubyvis'
require_relative 'analysis'

# Sizing and scales. */

puts @h
#data = pv.range(10).map {rand()}
#data = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]

data = Array.new
array = Array.new

@h.each do |key,value|
    array << key
    data << value
end


w = 600
h = 600

r = w / 2.0

a = pv.Scale.linear(0, pv.sum(data)).range(0, 2 * Math::PI)

#/* The root panel. */
vis = pv.Panel.new()
    .width(w)
    .height(h);
#/* The wedge, with centered label. */

vis.add(pv.Wedge)
     .data(data)
    .bottom(w / 2)
    .left(w / 2)
    .innerRadius(r - 40)
    .outerRadius(r)
    .angle(a)
    .event("mouseover", lambda {self.inner_radius(0)})
    .event("mouseout", lambda{ self.inner_radius(r - 40)})
    .anchor("center").add(pv.Label)
    .visible(lambda {|d|  d > 0.15})
    .textAngle(0)
    .text(lambda {array[self.index,1]});
    #  |d| "%0.2f" %  d });

vis.render();

puts vis.to_svg

data.clear
array.clear
