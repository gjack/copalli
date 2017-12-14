class TeamMember < ApplicationRecord
  belongs_to :user
  belongs_to :team
  belongs_to :organization
end
