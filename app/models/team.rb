class Team < ApplicationRecord
  belongs_to :organization

  validates :name, presence: true
  validates :name, uniqueness: { scope: :organization_id }

  has_many :members, through: :team_members, source: :users
end
