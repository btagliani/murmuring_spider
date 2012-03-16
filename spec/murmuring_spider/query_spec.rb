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
    def status_mock(opts = {})
      mock(Twitter::Status, opts)
    end

    let(:response) { [status_mock(:id => 10), status_mock(:id => 7)] }
    context 'when the request succeeds' do
      before do
        Twitter.should_receive(:user_timeline).with('fake-user', {}).and_return(response)
      end
      subject { MurmuringSpider::Query.add(:user_timeline, 'fake-user').collect_statuses }
      it { should == response }
    end

    context 'when requested twice' do
      let(:query) { MurmuringSpider::Query.add(:user_timeline, 'fake-user') }
      before do
        Twitter.should_receive(:user_timeline).with('fake-user', {}).and_return(response)
        Twitter.should_receive(:user_timeline).with('fake-user', {:since_id => 10}).and_return([])

        query.collect_statuses.should == response
      end

      subject { MurmuringSpider::Query.get(query.id).collect_statuses }
      it { should be_empty }
    end
  end
end
