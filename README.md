# MurmuringSpider

[![Build Status](https://secure.travis-ci.org/tomykaira/murmuring_spider.png)](http://travis-ci.org/tomykaira/murmuring_spider)


MurmuringSpider is a concise Twitter crawler.

When we write a data-mining / text-mining application based on twitter's timeline, we have to collect and store tweets first.

I am irritated with writing such crawler repeatedly, so I wrote this.

What you have to do is only to add query and to run them periodically.

Thanks to consistent Twitter API and [twitter gem](http://twitter.rubyforge.org/), it is quite easy to track various types of timelines (such as user_timeline, home_timeline, search...)

## Installation

Add this line to your application's Gemfile:

    gem 'murmuring_spider'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install murmuring_spider

## Usage

[Usage of murmuring spider — Gist](https://gist.github.com/2060445)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
