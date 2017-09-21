require "getpics/version"
require 'getpics/downloader'
require 'getpics/photo'

module Getpics
    if File.exists?("/usr/local/Cellar/exiftool/10.05/bin/exiftool")
        MiniExiftool.command = '/usr/local/Cellar/exiftool/10.05/bin/exiftool'
    else
        MiniExiftool.command = system("which exiftool")
    end
end

