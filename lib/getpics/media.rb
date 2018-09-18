require 'date'
require 'mini_exiftool'
require 'colorize'

module Getpics
    class Media
        attr_accessor :path, :orig_path, :date, :folder, :extension, :type, :target_name, :target_folder, :target_path

        RAW_EXTENSIONS = ['.nef', '.dng']
        DEVELOPED_EXTENSIONS = ['.jpg', '.jpeg']
        MOVIE_EXTENSIONS = ['.mov']

        def initialize(path)
            @path = path
            @orig_path = path
            @name = File.basename(@path)
            @folder = File.dirname(@path)
            @extension = File.extname(@path)
            @down_case_extension = File.extname(@path).downcase

            if ! @name.match?(/^_/)
                @name = "_" + @name
            end

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

            if RAW_EXTENSIONS.include?(@down_case_extension)
                @type = RawType.new
            elsif DEVELOPED_EXTENSIONS.include?(@down_case_extension)
                @type = DevelopedType.new
            elsif MOVIE_EXTENSIONS.include?(@down_case_extension)
                @type = MovieType.new
            else
                @type = UnknownType.new
            end

            @target_folder = "#{@type.folder}/#{year}/#{month}/#{day}/"
            @target_name = year_month_day + @name
            @target_path = @target_folder + @target_name

        end

        def path=(path)
            @path = path
        end

        def name
            File.basename(@path)
        end

        def folder
            File.dirname(@path)
        end

        def is_developed?
            return true if @type.name == :developed
            return false
        end

        def is_raw?
            return true if @type.name == :raw
            return false
        end

        def is_pic?
            return true if is_developed? or is_raw?
            return false
        end

        def is_movie?
            return true if @type.name == :movie
            return false
        end

        def is_unknown?
            return true if @type.name == :unknown
            return false
        end

        def is_known?
            return true if @type.name != :unknown
            return false
        end

        def year
            @date.year
        end

        def month
            @date.strftime("%m")
        end

        def day
            @date.strftime("%d")
        end

        def year_month_day
            @date.strftime("%Y%m%d")
        end

    end
end
