require 'date'
require 'mini_exiftool'

module Getpics

    class Photo
        attr_reader :path, :name, :date, :type

        def initialize(path)
            @path = path
            @name = File.basename(@path)
            image = MiniExiftool.new(@path) 
            @date = DateTime.parse(image.CreateDate.to_s)
            if File.extname(@path) == ".NEF"
                @type = 'raw'
            else
                @type = 'jpg'
            end
        end
    end
end
