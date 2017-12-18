class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organization
  validates :first_name, :last_name, :email, presence: true
  validates_confirmation_of :password

  has_many :teams, through: :team_members

  def name
    "#{first_name} #{last_name}"
  end
end
