require 'dm-core'
require 'dm-migrations'

require "murmuring_spider/version"
require "murmuring_spider/query"
require "murmuring_spider/status"

module MurmuringSpider
  extend MurmuringSpider

  def database_init(db)
    DataMapper.setup(:default, db)
    DataMapper.auto_upgrade!
  end
end
