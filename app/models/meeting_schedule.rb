class MeetingSchedule < ApplicationRecord
  belongs_to :team_member
  attribute :every, :integer
  attribute :frequency, :string
  attribute :day_of_week, :string

  before_create :set_recurrence_schedule

  def set_recurrence_schedule
    self.recurring = ScheduleCreator.new(
      start_time: start_time,
      every: every,
      frequency: frequency,
      day_of_week: day_of_week
    ).create_schedule
  end
end
