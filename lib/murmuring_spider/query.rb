require 'dm-core'
require 'dm-validations'
require 'twitter'

#
# Query: represents request to Twitter
#
class MurmuringSpider::Query
  include DataMapper::Resource

  property :id, Serial
  property :type, String
  property :target, String, :unique => :type
  property :opts, Object

  self.raise_on_save_failure = true

  class << self
    #
    # Add an query
    # * _type_ : request type.  Name of a Twitter's method
    # * _target_ : First argument of the Twitter's method.  Usually, an user or a query
    # * _opts_ : options. Second argument of the Twitter's method.
    #
    # returns : created Query instance
    #
    # raises : DataMapper::SaveFailureError
    #
    def add(type, target, opts = {})
      create(:type => type, :target => target, :opts => opts)
    end
  end

  #
  # Execute Twitter request and update :since_id of _opts_
  # This method has side effect
  #
  # returns : Array of Twitter::Status
  #
  def collect_statuses
    res = Twitter.__send__(type, target, opts)
    unless res.empty?
      self.opts = opts.merge(:since_id => res.first.id)
      save
    end
    res
  end

  #
  # Collect tweet statuses and save them
  #
  # returns : Array of MurmuringSpider::Status
  #
  def run
    collect_statuses.map { |s| MurmuringSpider::Status.create(s) }
  end
end
