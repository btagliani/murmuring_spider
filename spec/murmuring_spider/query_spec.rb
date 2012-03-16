require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MurmuringSpider::Query do
  describe 'add' do
    context 'when an user_timeline query is added' do
      subject { MurmuringSpider::Query }
      before { subject.add(:user_timeline, 'tomy_kaira') }
      it { should have(1).item }
    end
  end
end
