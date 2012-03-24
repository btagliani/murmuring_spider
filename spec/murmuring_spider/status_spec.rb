# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

shared_examples_for 'my tweet object' do
  its(:tweet_id) { should == '180864326289207297' }
  its(:text) { should == "OCaml でなにか書く課題がほしいです。プロコン的問題はのぞく" }
  its(:user_id) { should == '287606751' }
  its(:screen_name) { should == 'tomy_kaira' }
  its(:created_at) { should == DateTime.parse("Sat Mar 17 03:53:10 +0000 2012") }
end

describe MurmuringSpider::Status do
  let(:twitter_status) { Marshal.load(File.read(File.dirname(__FILE__) + '/../' + filename)) }
  subject { MurmuringSpider::Status.new(twitter_status) }

  context 'from user_timeline result' do
    let(:filename) { 'twitter_status.dump' }
    it_should_behave_like 'my tweet object'
  end

  context 'from search result' do
    let(:filename) { 'twitter_search_status.dump' }
    it_should_behave_like 'my tweet object'
  end

  context 'when the user extend the field' do
    let(:filename) { 'twitter_status.dump' }
    before do
      MurmuringSpider::Status.extend(:source)
    end
    it_should_behave_like 'my tweet object'
    its(:source) { should include 'web' }
  end

  context 'when the user extend the field with get strategy' do
    before do
      MurmuringSpider::Status.extend(:user_name) { |status| status.user ? status.user.name : status.from_user_name }
    end

    context 'with user_timeline result' do
      let(:filename) { 'twitter_status.dump' }
      its(:user_name) { should include 'といれ' }
    end

    context 'with search result' do
      let(:filename) { 'twitter_search_status.dump' }
      its(:user_name) { should include 'といれ' }
    end
  end

  context 'when the tweet has shortened URL' do
    let(:twitter_status) { Twitter::Status.new('text' => 'expansion test http://example.com/shortened', 'entities' => { 'urls' => [{"expanded_url"=>"http://www.example.com/expanded", "url"=>"http://example.com/shortened"}] }) }
    subject { MurmuringSpider::Status.new(twitter_status) }
    its(:text) { should ==  'expansion test http://www.example.com/expanded'}
  end
end
