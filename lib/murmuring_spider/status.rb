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
    property :extended, Object

    belongs_to :operation

    @@extended_fields = {}

    class << self
      def extend(field, &b)
        @@extended_fields[field] = b
        define_method(field.to_s) do
          extended[field]
        end
      end
    end

    def initialize(s)
      values = {}
      @@extended_fields.each do |field, func|
        if func
        else
          values[field] = s.__send__(field)
        end
      end
      super(:tweet_id => s.id,
          :text => s.text,
          :user_id => s.user ? s.user.id : s.from_user_id,
          :screen_name => s.user ? s.user.screen_name : s.from_user,
          :created_at => s.created_at,
          :extended => values)
    end
  end
end
