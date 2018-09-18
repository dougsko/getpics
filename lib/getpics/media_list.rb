module Getpics
    class MediaList
        def initialize
            @media_list = []
        end

        def add(media)
            @media_list << (media)
        end

        def size
            @media_list.size()
        end

        def raw_pics
            @media_list.select{ |media| media.is_raw? }
        end

        def developed_pics
            @media_list.select{ |media| media.is_developed? }
        end

        def pics
            @media_list.select{ |media| media.is_pic? }
        end

        def movies
            @media_list.select{ |media| media.is_movie? }
        end

        def all_known_media
            @media_list.select{ |media| media.is_known? }
        end
    end
end

