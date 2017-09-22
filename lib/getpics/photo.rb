require 'date'
require 'mini_exiftool'
require 'colorize'

module Getpics

    class Photo
        attr_accessor :path, :orig_path, :name, :date, :type

        def initialize(path)
            @path = path
            @orig_path = path
            @name = File.basename(@path)
            image = MiniExiftool.new(@path) 
            begin
                @date = DateTime.parse(image.CreateDate.to_s)
            rescue
                puts "No valid CreateDate for #{@path}.  Using mtime (#{File.mtime(@path)})".yellow
                @date = File.mtime(@path)
            end
            if File.extname(@path) == ".NEF" or File.extname(@path) == ".dng"
                @type = 'raw'
            else
                @type = 'jpg'
            end
        end
    end
end
