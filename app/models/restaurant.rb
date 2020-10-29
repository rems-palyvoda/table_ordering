class Restaurant < ApplicationRecord
  validates :name, presence: true
  validates :start_working_time, presence: true, inclusion: 0..23
  validates :end_working_time, presence: true, inclusion: 0..23

  validate :working_time

  def current_working_time
    # handle the case when restaurant end working time is on the current day
    beginning_of_day = Date.today.beginning_of_day
    [
      beginning_of_day + start_working_time.hours,
      beginning_of_day + end_working_time.hours 
    ]
  end

  private

  def working_time
    return unless end_working_time && start_working_time

    if end_working_time < start_working_time
      errors.add(:end_working_time, 'should be greather than start working time')
    end
  end
end

