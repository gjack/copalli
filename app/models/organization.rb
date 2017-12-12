class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :administrators, -> { where(account_administrator: true) }, class_name: "User"

  validates :name, presence: true, uniqueness: true
end
