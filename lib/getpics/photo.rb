require 'exiv2'
require 'date'

module Getpics

    class Photo
        attr_reader :path, :name, :date, :type

        def initialize(path)
            @path = path
            @name = File.basename(@path) + File.extname(@path)
            image = Exiv2::ImageFactory.open("#{@path}")
            image.read_metadata
            @date = Date.strptime(image.exif_data["Exif.Image.DateTime"], "%Y:%m:%d %H:%M:%S")
            if File.extname(@path) == ".NEF"
                @type = 'raw'
            else
                @type = 'jpg'
            end
        end
    end
end
