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
      super(:tweet_id => s.id,
          :text => s.text,
          :user_id => s.user ? s.user.id : s.from_user_id,
          :screen_name => s.user ? s.user.screen_name : s.from_user,
          :created_at => s.created_at)
    end
  end
end
