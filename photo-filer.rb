require 'find'
require 'fileutils'

class PhotoFiler

  def go
    puts "go go go 2b"
    move "src", "tgt", 1
  end

  def move(src, tgt, count)
    puts "Moving #{count} files from #{src} to #{tgt}"
    done = 0
    Find.find(src) do |path|
        # puts "#{path} - directory? #{FileTest.directory?(path)}"
        if FileTest.directory?(path)
            next
        else
            t = File.ctime(path)
            tgt_dir_year = t.year
            tgt_dir_month = "#{'%02d' % t.month}"
            puts "found path:#{path}, tgt dir:#{tgt_dir_year}/#{tgt_dir_month}"
            tgt_year_month = "#{tgt}/#{tgt_dir_year}/#{tgt_dir_month}"
            if !FileTest.directory?(tgt_year_month)
                FileUtils.mkdir_p tgt_year_month
            end
            FileUtils.move path, tgt_year_month
            done += 1
            if count > 0 && done >= count
                break
            end
        end
    end

end

end

core = PhotoFiler.new
core.go