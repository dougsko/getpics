module Getpics

    class Downloader
        def initialize(verbose, src_dir, pic_dest, movie_dest)
            @verbose = verbose
            @media = []
            @src_dir = src_dir
            @pic_dest = pic_dest
            @movie_dest = movie_dest
        end

        def load_pics
            raw_count = 0
            developed_count = 0
            movie_count = 0
            puts "Searching for media..."
            files = Dir.glob(@src_dir + "/**/*").reject { |p| File.directory? p }
            files.each do |file|
                if ! file.match(/\.xmp$/i)
                    media = Media.new(file)
                    raw_count += 1 if media.type == 'raw'
                    developed_count += 1 if media.type == 'developed'
                    movie_count += 1 if media.type == 'movie'
                    @media << media
                end
            end
            if @media.size == 0
                puts "No media found!".red
                exit 1
            end
            puts "Found #{raw_count} RAW photos".blue if raw_count > 0
            puts "Found #{developed_count} JPGs".blue if developed_count > 0
            puts "Found #{movie_count} movies".blue if movie_count > 0
        end

        def copy_pics
            puts "Copying media..."
            pb = ProgressBar.create(:title => "Images Copied", :total => @media.size)
            @media.each do |pic|
                if pic.type == 'raw'
                    type_folder = 'RAW'
                elsif pic.type == 'developed'
                    type_folder = 'developed'
                elsif pic.type == 'movie'
                    type_folder = "Raw\ Footage"
                end

                if pic.type != 'movie'
                    pic_folder = "#{@pic_dest}/#{type_folder}/#{pic.date.year}/#{pic.date.strftime("%m")}/#{pic.date.strftime("%d")}"
                else
                    pic_folder = "#{@movie_dest}/#{type_folder}/#{pic.date.year}/#{pic.date.strftime("%m")}/#{pic.date.strftime("%d")}"
                end
                if ! File.exists?("#{pic_folder}/#{pic.date.strftime("%Y%m%d")}" + "#{pic.name}")
                    pb.log ("Copying #{pic.path} to #{pic_folder}" + "/#{pic.date.strftime("%Y%m%d")}" + "#{pic.name}").light_black if @verbose
                    FileUtils.mkdir_p(pic_folder)
                    FileUtils.cp(pic.path, pic_folder + "/" +  "#{pic.date.strftime("%Y%m%d")}" + "#{pic.name}")
                    pic.path = "#{pic_folder}/#{pic.name}"
                else
                    puts ("#{pic_folder}/#{pic.date.strftime("%Y%m%d")}" + "#{pic.name} already exists!").light_black if @verbose
                end
                pb.increment
            end
        end

        def delete_pics
            @media.each do |pic|
                puts "Deleting #{pic.orig_path}".red if @verbose
                FileUtils.rm(pic.orig_path)
            end
        end

    end

end
