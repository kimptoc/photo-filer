require 'find'
require 'fileutils'

class PhotoFiler

  def go
    puts ">>PhotoFiler<<"
    count = -1 # unlimited, move all
    if ARGV.length < 2
        puts "Too few arguments: #{ARGV}"
        exit
    elsif ARGV.length == 3
        count = ARGV[2].to_i
    elsif ARGV.length > 3
        puts "Too many arguments: #{ARGV}"
        exit
    end
    move ARGV[0], ARGV[1], count
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