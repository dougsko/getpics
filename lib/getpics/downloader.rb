module Getpics
    class Downloader
        def initialize(verbose, src_dir, pic_dest, movie_dest)
            @verbose = verbose
            @src_dir = src_dir
            @pic_dest = pic_dest
            @movie_dest = movie_dest
            @media_list = MediaList.new()
        end

        def load_media
            puts "Searching for media..."
            files = Dir.glob(@src_dir + "/**/*").reject { |p| File.directory? p }
            files.each do |file|
                if ! file.match(/\.xmp$/i)
                    media = Media.new(file)
                    if media.is_pic?
                        media.target_path = "#{@pic_dest}/#{media.target_path}"
                        media.target_folder = "#{@pic_dest}/#{media.target_folder}"
                    elsif media.is_movie?
                        media.target_path = "#{@movie_dest}/#{media.target_path}"
                        media.target_folder = "#{@movie_dest}/#{media.target_folder}"
                    end
                    @media_list.add(media)
                end
            end
            if @media_list.size == 0
                puts "No media found!".red
                exit 1
            end
            puts "Found #{@media_list.raw_pics.size} RAW photos".blue if @media_list.raw_pics.size > 0
            puts "Found #{@media_list.developed_pics.size} JPGs".blue if @media_list.developed_pics.size > 0
            puts "Found #{@media_list.movies.size} movies".blue if @media_list.movies.size > 0
        end

        def copy_media
            puts "Copying media..."
            pb = ProgressBar.create(:title => "Media Copied", :total => @media_list.size)
            @media_list.all_known_media.each do |media|
                if ! File.exists?("#{media.target_path}")
                    pb.log ("Copying #{media.path} to #{media.target_path}").light_black if @verbose
                    FileUtils.mkdir_p(media.target_folder)
                    FileUtils.cp(media.path, media.target_path)
                    media.path = media.target_path
                else
                    pb.log ("#{media.target_name}" + " already exists!").light_black if @verbose
                end
                pb.increment
            end
        end

        def convert_media
            return if @media_list.movies.size == 0
            ffmpeg_path = which("ffmpeg")
            if ffmpeg_path == nil
                puts "ffmpeg not found!".red
                return
            end
            movies_to_process = []
            @media_list.movies.each do |movie|
                dest_path = "#{movie.target_folder}/#{File.basename(movie.target_name, '.MOV')}.mp4"
                if ! File.exists?(dest_path)
                    movies_to_process << movie
                else
                    puts "#{dest_path} already exists!".light_black if @verbose
                end
                return if movies_to_process.size == 0
                puts "Converting movies to MP4..."
                pb = ProgressBar.create(:title => "Movies Converted", :total => movies_to_process.size)
                movies_to_process.each do |movie|
                    system("#{ffmpeg_path} -i #{movie.target_path} -vcodec copy -acodec copy #{dest_path}")
                    pb.increment
                end
            end

            puts "Do you want to delete the .MOV files you just converted? [y/N]".yellow
            delete = gets.strip
            if delete == 'y'
                movies_to_process.each do |movie|
                    puts "Deleting #{movie.target_path}".red if @verbose
                    File.delete(movie.target_path)
                end
            end
        end

        def delete_media
            @media_list.all_known_media.each do |media|
                puts "Deleting #{media.orig_path}".red if @verbose
                FileUtils.rm(media.orig_path)
            end
        end

        def which(cmd)
            exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
            ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
                exts.each do |ext|
                    exe = File.join(path, "#{cmd}#{ext}")
                    return exe if File.executable?(exe) && !File.directory?(exe)
                end
            end
            return nil
        end

    end
end
