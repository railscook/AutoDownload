# e.g 500 ping google.com
# ping google.com
system(" history > myhistory ");
lines = File.readlines('myhistory')
lines.each {|line| puts line[7..-1]}
puts lines.size
