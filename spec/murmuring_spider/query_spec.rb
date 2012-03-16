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
end
