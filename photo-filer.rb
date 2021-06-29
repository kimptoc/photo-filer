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
    src = ARGV[0]
    tgt = ARGV[1]
    puts "Moving #{count<0 ? "ALL":count} files from #{src} to #{tgt}"
    start_time = Time.now
    moved = move src, tgt, count
    end_time = Time.now
    delta = end_time - start_time # in seconds
    puts "Moved #{moved} files from #{src} to #{tgt} in #{delta} seconds."
  end

  def move(src, tgt, count)
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
    return done
  end

end

core = PhotoFiler.new
core.go