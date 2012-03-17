# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MurmuringSpider::Status do
  context 'from user_timeline result' do
    let(:twitter_status) { Marshal.load(File.read(File.dirname(__FILE__) + '/../twitter_status.dump')) }

    subject { MurmuringSpider::Status.new(twitter_status) }
    its(:tweet_id) { should == '180864326289207297' }
    its(:text) { should == "OCaml でなにか書く課題がほしいです。プロコン的問題はのぞく" }
    its(:user_id) { should == '287606751' }
    its(:screen_name) { should == 'tomy_kaira' }
    its(:created_at) { should == DateTime.parse("Sat Mar 17 03:53:10 +0000 2012") }
  end
end
