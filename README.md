# Douban.fm.d

douban.fm favorites downloader

## Installation

Add this line to your application's Gemfile:

    gem 'douban.fm.d'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install douban.fm.d

## Usage

<pre>
douban.fm.d -h

NAME
    douban.fm.d - download your favorites songs in douban.fm

SYNOPSIS
    douban.fm.d [global options] command [command options] [arguments...]

VERSION
    0.2.0

HISTORY
    ~0.1->0.2 download from baidu due to top100.cn down

GLOBAL OPTIONS
    --help                  - Show this message
    -p, --password=password - douban.fm password (default:ENV["douban_password"])
    -u, --user=user         - douban.fm account name, normally an email address (default: ENV["douban_user"])
    -v, --[no-]verbose      - Show verbose information
    --version               -

COMMANDS
    download - Download all your favorites from douban.fm, or specify a song to
               download
    help     - Shows a list of commands or help for one command
    list     - List your favorites songs from douban.fm

</pre>


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
