class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organization
  validates :first_name, :last_name, :email, presence: true

  has_many :teams, through: :team_members
  has_many :meetings, through: :team_members

  def name
    "#{first_name} #{last_name}"
  end
end
