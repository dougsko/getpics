require "getpics/version"
require 'getpics/downloader'
require 'getpics/media'
require 'getpics/media_list'
require 'getpics/media_type'
require 'colorize'
require 'fileutils'
require 'ruby-progressbar'
require 'mini_exiftool'
require 'date'

module Getpics
    if File.exists?("/usr/local/Cellar/exiftool/10.05/bin/exiftool")
        MiniExiftool.command = '/usr/local/Cellar/exiftool/10.05/bin/exiftool'
    else
        MiniExiftool.command = `which exiftool`.chomp
    end
end

