require 'fileutils'
require 'ruby-progressbar'

module Getpics

    class Downloader
        def initialize
            @pics = []
            @src_dir = ""
            @dest_root = ""
        end

        def load_pics(dir)
            @src_dir = dir
            files = Dir.glob(@src_dir + "/**/*").reject { |p| File.directory? p }
            files.each do |file|
                if file.match(/\.NEF$/) or file.match(/\.jpg$/)
                    @pics << Photo.new(file)
                end
            end
            if @pics.size == 0
                puts "No pictures found!"
                exit 1
            end
            puts "Found #{@pics.size} pictures."
        end

        def copy_pics(dest_root)
            @dest_root = dest_root
            pb = ProgressBar.create(:title => "Images Copied", :total => @pics.size)
            @pics.each do |pic|
                if pic.type == 'raw'
                    type_folder = 'RAW'
                else
                    type_folder = 'developed'
                end

                pic_folder = "#{@dest_root}/#{type_folder}/#{pic.date.year}/#{pic.date.month}/#{pic.date.day}"
                FileUtils.mkdir_p(pic_folder)

                FileUtils.cp(pic.path, pic_folder)
                pb.increment
            end
        end

        def delete_pics
            puts "Do you want to delete #{@pics.size} pics from #{@src_dir}? [y/N]"
            confirm = gets.strip
            if confirm == "y"
                pb = ProgressBar.create(:title => "Images Deleted", :total => @pics.size)
                @pics.each do |pic|
                    FileUtils.rm(pic.path)
                    pb.increment
                end
            else
                puts "Deletion cancelled."
            end
        end

        def rename_pics(dir)
            puts "Renaming pics"
            pics = []
            files = Dir.glob(dir + "/RAW/**/*").reject { |p| File.directory? p }
            files.each do |file|
                if file.match(/\.NEF$/) or file.match(/\.jpg$/) or file.match(/\.dng$/)
                    pics << Photo.new(file)
                end
            end
            pics.each do |pic|
                File.rename(pic.path, "#{File.dirname(pic.path)}" + "/" + "#{pic.date.strftime("%Y%m%d")}" + "#{pic.name}")
            end
        end

    end

end
