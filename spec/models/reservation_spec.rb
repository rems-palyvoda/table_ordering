require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:user) { User.create } 
  let(:table) { Table.create(restaurant: restaurant) }
  let(:restaurant) { Restaurant.create(name: 'res', start_working_time: 1, end_working_time: 3) }
  let(:reservation) { described_class.new(attributes) }
  let(:attributes) do
    {
      user: user, 
      table: table,
      start_time: DateTime.now,
      time_offset: 30
    }
  end

  describe 'validations' do
    context 'when attributes are valid' do
      subject { reservation }

      it { is_expected.to be_valid }
    end

    context 'when time offset is not multiple for 30' do
      before do
        attributes[:time_offset] = 31
        reservation.valid?
      end

      subject { reservation.errors.messages[:time_offset] }

      it 'adds the error message' do
        is_expected.to include('should be multiple of 30')
      end
    end
  end

  describe '.end_time' do
    let(:expected_end_time) { DateTime.parse('Thu, 29 Oct 2020 00:30:00 +0200') }

    before do
      attributes[:start_time] = DateTime.parse('Thu, 29 Oct 2020 00:00:00 +0200')
    end

    subject { reservation.end_time }

    it { is_expected.to eq(expected_end_time) }
  end
end
