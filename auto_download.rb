class AutoDownload
  attr_accessor :file_pattern, :link_path, :lines, :links, :dir, :sub_dir, :filename
  def initialize
  	p "Please fill the pattern (e.g .mov )"
		file_pattern = gets
    file_pattern.chomp!

		p "Please fill the link_path (e.g http://google.com/videos/ OR http://google.com/home.htm )"
		link_path = gets 
		link_path.chomp!
		# Remove / at the end (because system will put / for link)
	  if(link_path.reverse[0..0] == "/")
	 		link_path = link_path[0..link_path.size-2]
    end

    # if http:// is not present
    link_path = ["http://", link_path].join('') unless link_path.include?("://")

    @file_pattern, @link_path = file_pattern, link_path
    @links, @lines = [], ""
		@dir, @sub_dir, @filename = link_path.split("/")[2], "download", "links.txt" 

  end

  def start
		download_webpages
		grap_filenames
  	generate_links
		create_file
		create_dir
		download
  end

  def download_webpages
		# DOWNLOAD WEBPAGES RECURSIVELY
	  Dir.mkdir(@dir) unless File.directory?(@dir)
	  Dir.chdir(@dir) 
    recursive = @link_path.include?('.') ? "" : "-r"
    link = [recursive, @link_path].join('')
    if link.include?(".htm")
      wget(link)
    else
      name = link.split("/").last
      system("wget -O #{name}.htm #{link}")
    end

  end

  def is_correct_file_extension?(link, file_pattern)
    #link.split(".").last == @file_pattern.split(".").last
    # .mp3?
    link =~ /(.\w+)\z/i
    extension = $1
    extension == file_pattern
  end

  def grap_filenames
		#GRAP FILENAMES FROM FILE
		 files = Dir["*"] 
		 files.each do |file|
			 unless File.directory?(file)
				 lines = File.readlines(file)
				 lines.each do |line|
					 if line.include?(file_pattern)
						 #puts "#{file} - #{@file_pattern} - #{!(line =~  /href=(\S+)>/i).nil?}"
						 if !(line =~ /href=(\S+)>/i ).nil?
								link = $1
                #if is_correct_file_extension?(link, @file_pattern)
                  @links << link.gsub("\"", "")
                #end
						 end
					 end
				 end
			 end
		 end
  end

	def generate_links
	 #GENERATE LINK PATH AND ADD IN LINES
	 @lines = ""
	 @links.uniq.compact.each do |x|
	 link = x
	 @lines << "#{link} \r\n"
	 end
	end

	def create_file
	 #PUT LINK LISTS IN FILE
	 File.open(@filename, 'w+'){|f|f.write(@lines)}
	end

	def read_file
	 #READ FILE
	 File.readlines(@filename)
	end

	def create_dir
	 #CREATE DIRECTORY TO DOWNLOAD
	 Dir.mkdir(@sub_dir) unless File.directory?(@sub_dir)
	 Dir.chdir(@sub_dir)
	end

  def download_from_string
   @lines = @lines.split("\r\n")
   @lines.each do |line|
      wget(line)
   end
  end

  def wget(link)
      begin
        text = " wget #{link}"
        puts text.inspect
        system(text)
      rescue Exception => e
      end
  end

	def download 
	 #DOWNLOAD LINK BY LINK
    
    return download_from_string if @lines.is_a?(String)
    @lines.each do |line|
  	 link = line.split(" ").first
	   file = link.split("/").last
     unless link.include?("://")
       link = [@link_path, link].join('')
     end
		  unless File.exist? file
        wget(link)
		  end
	  end
	end
end

ad = AutoDownload.new
ad.start

