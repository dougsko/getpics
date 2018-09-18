module Getpics
    class MediaType
        attr_accessor :name, :folder
    end

    class RawType < MediaType
        def initialize
            @name = :raw
            @folder = 'RAW'
        end
    end

    class DevelopedType < MediaType
        def initialize
            @name = :developed
            @folder = 'developed'
        end
    end

    class MovieType < MediaType
        def initialize
            @name = :movie
            @folder = "Raw_Footage"
        end
    end

    class UnknownType < MediaType
        def initialize
            @name = :unknown
            @folder = "#{ENV['HOME']}/Desktop"
        end
    end

end
