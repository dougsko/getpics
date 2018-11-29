# Getpics

Use this script to copy and organize media files from your camera or
other media source in one step. It will copy your files to a
```<dest>/YYYY/mm/dd/``` type folder structure, and add the file's
creation date to its name.  It can also optionally convert quicktime
files (.mov) to .mp4, using ```ffmpeg``` if it's installed on the
system.

## Installation

    $ gem install getpics

## Usage

    Usage: getpics [options]
        -s, --src DIR                    Source directory
        -p, --photo DIR                  Photo Destination directory
        -m, --movie DIR                  Movie Destination directory
        -c, --convert                    Convert movies to mp4
        -v, --verbose                    Verbose
        -h, --help                       Show this message
    Version: 0.2.3

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dougsko/getpics.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
