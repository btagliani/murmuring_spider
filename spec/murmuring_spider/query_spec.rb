require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MurmuringSpider::Query do
  describe 'add' do
    subject { MurmuringSpider::Query }
    context 'when an user_timeline query is added' do
      before { subject.add(:user_timeline, 'tomy_kaira') }
      it { should have(1).item }
    end

    context 'when the same query is added' do
      before { subject.add(:user_timeline, 'tomy_kaira') }
      it "should raise error" do
        expect { subject.add(:user_timeline, 'tomy_kaira') }.to raise_error(DataMapper::SaveFailureError)
      end
    end
  end

  describe 'collect_statuses' do
    context 'when the request succeeds' do
      let(:response) { [:fake_tweet, :fake_tweet2] }
      before do
        Twitter.should_receive(:user_timeline).with('fake-user', {}).and_return(response)
      end
      subject { MurmuringSpider::Query.add(:user_timeline, 'fake-user').collect_statuses }
      it { should == response }
    end
  end
end
