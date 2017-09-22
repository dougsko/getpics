require "getpics/version"
require 'getpics/downloader'
require 'getpics/photo'
require 'colorize'
require 'fileutils'
require 'ruby-progressbar'
require 'mini_exiftool'
require 'date'

module Getpics
    if File.exists?("/usr/local/Cellar/exiftool/10.05/bin/exiftool")
        MiniExiftool.command = '/usr/local/Cellar/exiftool/10.05/bin/exiftool'
    else
        MiniExiftool.command = system("which exiftool")
    end
end

