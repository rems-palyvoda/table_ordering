class Reservation < ApplicationRecord
  belongs_to :table
  belongs_to :user

  validates :table, presence: true
  validates :user, presence: true
  validates :start_time, presence: true
  validates :time_offset, presence: true

  validate :time_offset_format,
           :restaurant_schedule,
           :table_reserved

  def end_time
    start_time + time_offset.minutes
  end

  def period
    [start_time, end_time]
  end

  private

  def time_offset_format
    return unless time_offset

    unless time_offset % 30 == 0
      errors.add(:time_offset, 'should be multiple of 30')
    end
  end

  def restaurant_schedule
    allowed_hours = table.restaurant.current_working_time
    error_message = 'out of restaurant working hours'

    unless start_time.between?(*allowed_hours) && end_time.between?(*allowed_hours)
      errors.add(:start_time, error_message)
      errors.add(:time_offset, error_message)
    end
  end

  def table_reserved
    # it's better to calculate end_time and store it to the databse
    # it could help us to write an optimized SQL query to avoid N+1 problem 
    reserved = false

    table.reservations.each do |reservation|
      if self.start_time.between?(*reservation.period) && self.start_time.between?(*reservation.period)
        reserved = true
        break
      end
    end

    errors.add(:table, 'is already reserved') if reserved
  end
end
