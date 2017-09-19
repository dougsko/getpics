require "getpics/version"
require 'gphoto2'

module Getpics
    class Downloader
        MAGNITUDES = %w[bytes KiB MiB GiB].freeze

        def initialize
            @cameras = GPhoto2::Camera.all
            if @cameras.empty?
                puts "No cameras found!"
            else
                @cameras.map { |c| [c.model, c.port] }
            end
        end

        # @param [Integer] size filesize in bytes
        # @param [Integer[ precision
        # @return [String]
        def format_filesize(size, precision = 1)
            n = 0

            while size >= 1024.0 && n < MAGNITUDES.size
                size /= 1024.0
                n += 1
            end

            "%.#{precision}f %s" % [size, MAGNITUDES[n]]
        end

        # @param [CameraFolder] folder a root directory
        def visit(folder)
            files = folder.files

            puts "#{folder.path} (#{files.size} files)"

            files.each do |file|
                info = file.info

                name = file.name
                # Avoid using `File#size` here to prevent having to load the data along
                # with it.
                size = format_filesize(info.size)
                mtime = info.mtime.utc.iso8601

                if info.has_field?(:width) && info.has_field?(:height)
                    dimensions = "#{info.width}x#{info.height}"
                else
                    dimensions = '-'
                end

                puts "#{name.ljust(30)}  #{size.rjust(12)}  #{dimensions.rjust(12)}  #{mtime}"
            end

            puts

            folder.folders.each { |child| visit(child) }
        end

        def list_files
            if ! @cameras.empty?
            @cameras.first do |camera|
                visit(camera.filesystem)
            end
            else
                puts "No cameras found so there's nothing to list!"
            end
        end
    end
end
