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

  describe 'run' do
    let(:user) { mock(Twitter::User, :id => 12345, :screen_name => 'fake-user') }
    let(:status) { double(:id => 10,
                   :user => user,
                   :text => 'test tweet',
                   :created_at => "Fri Mar 16 09:04:34 +0000 2012").as_null_object }
    before do
      Twitter.should_receive(:user_timeline).with('fake-user', {}).and_return([status])
    end

    subject { MurmuringSpider::Query.add(:user_timeline, 'fake-user').run }

    it { should have(1).item }
    its(:first) { should be_instance_of MurmuringSpider::Status }

    it 'should create Status instance' do
      subject
      MurmuringSpider::Status.should have(1).item
      MurmuringSpider::Status.first(:tweet_id => 10).should_not be_nil
    end
  end

  def status_mock(opts = {})
    mock(Twitter::Status, opts)
  end
end
