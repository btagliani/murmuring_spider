# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

shared_examples_for 'my tweet object' do
  subject { MurmuringSpider::Status.new(twitter_status) }
  its(:tweet_id) { should == '180864326289207297' }
  its(:text) { should == "OCaml でなにか書く課題がほしいです。プロコン的問題はのぞく" }
  its(:user_id) { should == '287606751' }
  its(:screen_name) { should == 'tomy_kaira' }
  its(:created_at) { should == DateTime.parse("Sat Mar 17 03:53:10 +0000 2012") }
end

describe MurmuringSpider::Status do
  let(:twitter_status) { Marshal.load(File.read(File.dirname(__FILE__) + '/../' + filename)) }
  context 'from user_timeline result' do
    let(:filename) { 'twitter_status.dump' }
    it_should_behave_like 'my tweet object'
  end

  context 'from search result' do
    let(:filename) { 'twitter_search_status.dump' }
    it_should_behave_like 'my tweet object'
  end
end
