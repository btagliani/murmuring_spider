require 'dm-core'
require 'dm-migrations'

require "murmuring_spider/version"
require "murmuring_spider/operation"
require "murmuring_spider/status"

module MurmuringSpider
  extend MurmuringSpider

  def database_init(db)
    DataMapper.setup(:default, db)
    DataMapper.auto_upgrade!
  end
end
