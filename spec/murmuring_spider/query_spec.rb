require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MurmuringSpider::Query do
  let(:query) { MurmuringSpider::Query.add(:user_timeline, 'fake-user') }

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
    before { twitter_expectation }

    context 'when the request succeeds' do
      subject { query.collect_statuses }
      it { should == response }
    end

    context 'when requested twice' do
      before do
        twitter_expectation({:since_id => 10}, [])
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
    before { twitter_expectation({}, [status]) }

    it 'should create Status instance' do
      query.run
      MurmuringSpider::Status.should have(1).item
      status = MurmuringSpider::Status.first(:tweet_id => 10)
      status.should_not be_nil
      status.query.id.should == query.id
    end
  end

  def status_mock(opts = {})
    mock(Twitter::Status, opts)
  end

  def twitter_expectation(opts = {}, resp = response)
    Twitter.should_receive(:user_timeline).with('fake-user', opts).and_return(resp)
  end
end
