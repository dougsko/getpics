module Getpics

    class Downloader
        def initialize(verbose)
            @verbose = verbose
            @pics = []
            @src_dir = ""
            @dest_root = ""
        end

        def load_pics(dir)
            puts "Searching for photos..."
            @src_dir = dir
            files = Dir.glob(@src_dir + "/**/*").reject { |p| File.directory? p }
            files.each do |file|
                if file.match(/\.NEF$/i) or file.match(/\.jpg$/i) or file.match(/\.dng$/i)
                    @pics << Photo.new(file)
                end
            end
            if @pics.size == 0
                puts "No pictures found!".red
                exit 1
            end
            puts "Found #{@pics.size} photos"
        end

        def copy_pics(dest_root)
            puts "Copying photos..."
            @dest_root = dest_root
            pb = ProgressBar.create(:title => "Images Copied", :total => @pics.size)
            @pics.each do |pic|
                if pic.type == 'raw'
                    type_folder = 'RAW'
                else
                    type_folder = 'developed'
                end

                pic_folder = "#{@dest_root}/#{type_folder}/#{pic.date.year}/#{pic.date.month}/#{pic.date.day}"
                if ! File.exists?("#{pic_folder}/#{pic.date.strftime("%Y%m%d")}" + "#{pic.name}")
                    pb.log "Copying #{pic.path} to #{pic_folder}".light_black if @verbose
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
            @pics.each do |pic|
                puts "Deleting #{pic.orig_path}".red if @verbose
                FileUtils.rm(pic.orig_path)
            end
        end

    end

end
