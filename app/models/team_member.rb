class TeamMember < ApplicationRecord
  belongs_to :user
  belongs_to :team
  belongs_to :organization
  has_many :meeting_schedules
end
