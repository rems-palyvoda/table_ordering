require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  let(:restaurant) { described_class.new(name: 'res', start_working_time: 1, end_working_time: 3) }

  describe 'validations' do
    subject { restaurant }

    context 'valid record' do
      it { is_expected.to be_valid }
    end
  
    context 'when end working time is less than start working time' do
      before do
        restaurant.start_working_time = 3
        restaurant.end_working_time = 1
      end
  
      it { is_expected.to be_invalid }
    end
  end

  describe '.current_working_time' do
    subject { restaurant.current_working_time }

    it { is_expected.to eq([
      Date.today.beginning_of_day + 1.hours,
      Date.today.beginning_of_day + 3.hours,
    ]) }
  end
end
