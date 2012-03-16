require 'dm-core'
require 'twitter'

module MurmuringSpider
  class Status
    include DataMapper::Resource
    property :id, Serial
    property :tweet_id, String
    property :text, String, :length => 255
    property :user_id, String
    property :screen_name, String
    property :created_at, DateTime

    belongs_to :operation

    def initialize(s)
      super(:tweet_id => s.id, :text => s.text, :user_id => s.user.id,
      :screen_name => s.user.screen_name, :created_at => s.created_at)
    end
  end
end
