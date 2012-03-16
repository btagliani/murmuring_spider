require 'dm-core'
require 'dm-validations'

class MurmuringSpider::Query
  include DataMapper::Resource

  property :id, Serial
  property :type, String
  property :target, String
  property :opts, Object

  class << self
    def add(type, target, opts = {})
      create!(:type => type, :target => target, :opts => opts)
    end
  end
end
