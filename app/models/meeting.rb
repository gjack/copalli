class Meeting < ApplicationRecord
  belongs_to :meeting_schedule
  belongs_to :team_member
  belongs_to :organization

  def date_string
    date.strftime("%-m/%d/%Y")
  end
end
