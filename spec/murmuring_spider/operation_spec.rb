require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MurmuringSpider::Operation do
  let(:operation) { MurmuringSpider::Operation.add(:user_timeline, 'fake-user') }

  subject { MurmuringSpider::Operation }
  describe 'add' do
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

    context 'when an operation with different types and the same target is added' do
      before { subject.add(:user_timeline, 'tomy_kaira') }
      it "should create new operation" do
        subject.add(:search, 'tomy_kaira')
        subject.count.should == 2
      end
    end
  end

  describe 'run_all' do
    before do
      subject.add(:user_timeline, 'fake-user')
      subject.add(:favorite, 'fake-user2')

      Twitter.should_receive(:user_timeline).with('fake-user', anything).and_return([])
      Twitter.should_receive(:favorite).with('fake-user2', anything).and_return([])
    end

    it "should run all tasks" do
      subject.run_all
    end
  end

  describe 'remove' do
    before do
      operation.should_not be_nil
    end

    it "should remove the operation" do
      subject.remove(:user_timeline, 'fake-user')
      subject.get(operation.id).should be_nil
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

  context 'when an instance of Twitter::Client is given' do
    let(:client) { mock(Twitter::Client) }
    it "should use the instance, not Twitter module" do
      client.should_receive(:user_timeline).with('fake-user', anything).and_return([])
      operation.collect_statuses(client).should == []
    end
  end

  describe 'run' do
    let(:user) { mock(Twitter::User, :id => 12345, :screen_name => 'fake-user', :name => 'fake user') }
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

    context 'when the same tweet is returned by API twice' do
      before do
        operation.run
        Twitter.should_receive(:user_timeline).and_return([status])
        operation.run
      end

      it 'should create only one instance' do
        MurmuringSpider::Status.should have(1).item
      end
    end
  end

  def status_mock(opts = {})
    mock(Twitter::Status, opts)
  end

  def twitter_expectation(opts = {}, resp = response)
    Twitter.should_receive(:user_timeline).with('fake-user', opts).and_return(resp)
  end
end
