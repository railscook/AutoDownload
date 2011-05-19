# <!-- Start partail of app/views/users/_user.rb -->
# First
# <!-- End partial of app/views/users/_user.rb -->
def is_file?(file)
  !is_directory?(file)
end

def is_partial?(file)
  file[0] == "_"
end

def is_directory?(dir)
  File.directory? dir
end

def change_dir(current_dir, dir) 
  current_dir
  Dir.chdir dir
  Dir.pwd  
end

def get_lists(dir)
  Dir["*"]
end

main_root = Dir.pwd
current_dir = change_dir(change_dir(main_root, "app"), "views")
 
root = current_dir.split("/")
lists = get_lists(current_dir)
lists.each do |list|
 path = Array.new(root)
 path << list
  file = path.join("/")
  if is_file?(file) 
    lines = File.readlines(file) if is_partial?(file)
  else
    puts list
    change_dir(current_dir, list)
    puts Dir.pwd
  end
end



(root_arr << %w{app views}).flatten!
Dir.chdir root_arr.join("/")
dirs = Dir["*"]




root_arr << dirs.first

