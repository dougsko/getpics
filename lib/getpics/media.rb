require 'date'
require 'mini_exiftool'
require 'colorize'

module Getpics

    class Media
        attr_accessor :path, :orig_path, :name, :date, :type

        def initialize(path)
            @path = path
            @orig_path = path
            @name = File.basename(@path)
            begin
                image = MiniExiftool.new(@path)
            rescue
                puts "Error while loading #{@path}".red
            end

            begin
                @date = DateTime.parse(image.CreateDate.to_s)
            rescue
                puts "No valid CreateDate for #{@path}.  Using mtime (#{File.mtime(@path)})".light_black
                @date = File.mtime(@path)
            end
            if File.extname(@path) == ".NEF" or File.extname(@path) == ".dng"
                @type = 'raw'
            elsif File.extname(@path) == ".jpg" or File.extname(@path) == ".JPG"
                @type = 'developed'
            elsif File.extname(@path) == ".MOV"
                @type = 'movie'
            else
                @type = 'unknown'
            end
        end
    end
end
