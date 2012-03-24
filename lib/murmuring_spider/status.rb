require 'dm-core'
require 'twitter/status'

class Twitter::Status
  def url_expanded_text
    if @attrs['entities'].nil?
      text
    else
      @url_expanded_text ||= Array(@attrs['entities']['urls']).reduce(text) do |t, url|
        t.gsub(url['url'], url['expanded_url'])
      end
    end
  end
end

module MurmuringSpider
  class Status
    include DataMapper::Resource
    property :id, Serial
    property :tweet_id, String, :unique => :operation_id
    property :text, String, :length => 255
    property :user_id, String
    property :screen_name, String
    property :created_at, DateTime
    property :extended, Object

    belongs_to :operation

    @@extended_fields = {}

    class << self

      #
      # extend fields
      # You can save a parameter of status which is not supported by default
      # If block given, initializer gives the _Twitter::Status_ object to it,
      # and the result of the given block is used as the field value
      #
      # * _field_ : field name. String or Symbol is expected.
      #   _Twitter::Status_ should have the same name method.
      # * _&b_ : block to get the field value from _Twitter::Status_ object.
      #
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
          values[field] = func.call(s)
        else
          values[field] = s.__send__(field)
        end
      end
      super(:tweet_id => s.id,
          :text => s.url_expanded_text,
          :user_id => s.user ? s.user.id : s.from_user_id,
          :screen_name => s.user ? s.user.screen_name : s.from_user,
          :created_at => s.created_at,
          :extended => values)
    end
  end
end
