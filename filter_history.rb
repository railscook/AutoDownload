#!/usr/bin/env ruby
begin
system("history >> myhistory")
rescue
end
lines = File.readlines('myhistory')
lines.each {|line| puts line[7..-1]}
puts lines.size

