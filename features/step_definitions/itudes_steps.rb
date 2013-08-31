Given(/^the itudes are instantiated with strings \((\d+\.\d+),(\d+\.\d+)\)$/) do |lat, lon|
  @lat, @lon = lat, lon
  @itudes = Geo::Itudes.new lat.to_s, lon.to_s
end

Given(/^the itudes are instantiated with floats \((\d+\.\d+),(\d+\.\d+)\)$/) do |lat, lon|
  @lat, @lon = lat, lon
  @itudes = Geo::Itudes.new lat.to_f, lon.to_f
end

Given(/^the itudes are instantiated with an array \((\d+\.\d+),(\d+\.\d+)\)$/) do |lat, lon|
  @lat, @lon = lat, lon
  @itudes = Geo::Itudes.new [lat, lon]
end

Given(/^the itudes are instantiated with a string \((\d+°\d+′\d+″N),(\d+°\d+′\d+″E)\)$/) do |lat, lon|
  @lat, @lon = lat, lon
  @itudes = Geo::Itudes.new "#{@lat},#{@lon}"
end

Given(/^the itudes are instantiated with a string \(([a-z]+):([a-z]+)\)$/) do |lat, lon|
  @lat, @lon = lat, lon
  @itudes = Geo::Itudes.new "#{@lat},#{@lon}"
end

When(/^I call `to_s` method$/) do
  @itudes_to_s = @itudes.to_s
end

When(/^I call `to_a` method$/) do
  @itudes_to_a = @itudes.to_a
end

Then(/^the proper string is to be created$/) do
  @itudes_to_s.should == "#{@lat.to_itude},#{@lon.to_itude}"
end

Then(/^the proper array is to be created$/) do
  @itudes_to_a.should == [@lat.to_itude.to_f, @lon.to_itude.to_f]
end

Then(/^the value is considered to be valid$/) do
  @itudes.valid?.should == true
end

Then(/^the value is not considered to be valid$/) do
  @itudes.valid?.should == false
end

When(/^the other itudes are instantiated with an array \((\d+ \d+ \d+N),(\d+ \d+ \d+W)\)$/) do |lat, lon|
  @itudes_other_km = Geo::Itudes.new lat, lon
  @itudes_other_mi = Geo::Itudes.new(lat, lon).miles!
end

Then(/^the distance equals to (\d+) km$/) do |dist_km|
  (@itudes_other_km - @itudes).to_i.should == dist_km.to_i
end

Then(/^the distance in miles equals to (\d+) mi$/) do |dist_mi|
  (@itudes_other_mi - @itudes).to_i.should == dist_mi.to_i
end

Given(/^the itudes are given with a string \((.+)\)$/) do |i1|
  @i1 = i1
end

Given(/^the other itudes are given with a string \((.+)\)$/) do |i2|
  @i2 = i2
end

Then(/^the classs method gives distance equals to (\d+) km$/) do |dist_km|
  Geo::Itudes.distance(@i2, @i1).to_i.should == dist_km.to_i
end

Then(/^the rounded value should equal to \((.+)\)$/) do |rounded|
  @itudes.round.should == Geo::Itudes.new(rounded)
  @itudes.round.should == rounded
end

When(/^the distance is calculated by implicit “\- "(.*?)"”$/) do |other|
  @calc_dist = @itudes - other
end

Then(/^the calculated distance equals to (\d+) km$/) do |dist|
  dist.to_i.should == @calc_dist.to_i
end
