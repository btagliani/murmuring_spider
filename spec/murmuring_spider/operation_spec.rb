require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MurmuringSpider::Operation do
  let(:operation) { MurmuringSpider::Operation.add(:user_timeline, 'fake-user') }

  describe 'add' do
    subject { MurmuringSpider::Operation }
    context 'when an user_timeline operation is added' do
      before { subject.add(:user_timeline, 'tomy_kaira') }
      it { should have(1).item }
    end

    context 'when the same operation is added' do
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
      subject { operation.collect_statuses }
      it { should == response }
    end

    context 'when requested twice' do
      before do
        twitter_expectation({:since_id => 10}, [])
        operation.collect_statuses.should == response
      end

      subject { MurmuringSpider::Operation.get(operation.id).collect_statuses }
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
      operation.run
      MurmuringSpider::Status.should have(1).item
      status = MurmuringSpider::Status.first(:tweet_id => 10)
      status.should_not be_nil
      status.operation.id.should == operation.id
    end
  end

  def status_mock(opts = {})
    mock(Twitter::Status, opts)
  end

  def twitter_expectation(opts = {}, resp = response)
    Twitter.should_receive(:user_timeline).with('fake-user', opts).and_return(resp)
  end
end
