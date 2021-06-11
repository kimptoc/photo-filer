require 'find'

class PhotoFiler

  def go
    puts "go go go 2b"
    move "src", "tgt", 5
  end

  def move(src, tgt, count)
    puts "Moving #{count} files from #{src} to #{tgt}"
    Find.find(src) do |path|
        # puts "#{path} - directory? #{FileTest.directory?(path)}"
        if FileTest.directory?(path)
            next
        else
            puts "found path:#{path}, ctime:#{File.ctime(path).year}"
        end
    end

end

end

core = PhotoFiler.new
core.go