class Team < ApplicationRecord
  belongs_to :organization

  validates :name, presence: true
  validates :name, uniqueness: { scope: :organization_id }

  has_many :team_members
  has_many :meeting_schedules, through: :team_members

  def manager
    team_members.where(role: "manager").first
  end
end
