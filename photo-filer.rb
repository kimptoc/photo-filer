require 'find'
require 'fileutils'
require "yaml"

class PhotoFiler

  ARGS_FILE = "last_args.yaml"

  def go
    puts ">>PhotoFiler<<"
    count = -1 # unlimited, move all
    if ARGV.length == 1 && ARGV[0] == "-repeat" && File.file?(ARGS_FILE)
        # see if previous args available
        src, tgt, count = YAML.load(File.read(ARGS_FILE))
    elsif ARGV.length < 2
        puts "Too few arguments: #{ARGV}"
        exit
    elsif ARGV.length == 3
        src = ARGV[0]
        tgt = ARGV[1]    
        count = ARGV[2].to_i
    elsif ARGV.length > 3
        puts "Too many arguments: #{ARGV}"
        exit
    else
        src = ARGV[0]
        tgt = ARGV[1]    
    end
    File.write(ARGS_FILE, [src, tgt, count].to_yaml)

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
            next # skip subdirectories
        elsif File.basename(path).start_with?('.')
            next # skip hidden files, those starting with a dot.
        else
            ct = File.ctime(path)
            at = File.atime(path)
            mt = File.mtime(path)
            #puts "File:#{path}, ctime:#{ct}, atime:#{at}, mtime:#{mt}"

            t = mt
            tgt_dir_year = t.year
            tgt_dir_month = "#{'%02d' % t.month}"
            puts "found path:#{path}, tgt dir:#{tgt_dir_year}/#{tgt_dir_month} (file time:#{t})"
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