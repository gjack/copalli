class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :administrators, -> { where(account_administrator: true) }, class_name: "User"
  has_many :teams, dependent: :destroy
  has_many :team_members, through: :teams

  validates :name, presence: true, uniqueness: true
end
