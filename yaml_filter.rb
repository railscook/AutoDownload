require 'yaml'

def pretty_title(txt)
  arr = []
  len = txt.size
  len.times { arr << '='}
  line = arr.join('')
  puts line + "\n" + txt + "\n" + line

end

title = "File lists"
pretty_title(title)

puts `ls`
puts "\nEnter the yaml filename"
filename = gets
filename.strip!
puts filename.inspect
data = YAML::load_file(filename)
puts data

#key
puts 'Enter the key get from above to count num of data'
my_key = gets
my_key.strip!
cc = data[my_key].count
puts "Number of data: " + cc
