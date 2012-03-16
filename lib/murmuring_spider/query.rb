require 'dm-core'
require 'dm-validations'
require 'twitter'

class MurmuringSpider::Query
  include DataMapper::Resource

  property :id, Serial
  property :type, String
  property :target, String, :unique => :type
  property :opts, Object

  self.raise_on_save_failure = true

  class << self
    def add(type, target, opts = {})
      create(:type => type, :target => target, :opts => opts)
    end
  end

  def collect_statuses
    Twitter.__send__(type, target, opts)
  end
end
