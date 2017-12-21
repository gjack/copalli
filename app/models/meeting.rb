class Meeting < ApplicationRecord
  belongs_to :meeting_schedule
  belongs_to :team_member
  belongs_to :organization

  scope :scheduled_meetings, -> { where(scheduled: true) }
  scope :unscheduled_meetings, -> { where(scheduled: false) }

  def date_string
    date.strftime("%-m/%d/%Y")
  end
end
