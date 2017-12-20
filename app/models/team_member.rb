class TeamMember < ApplicationRecord
  include UserInfo

  belongs_to :user
  belongs_to :team
  belongs_to :organization
  has_one :meeting_schedule
  has_many :meetings

  attribute :email, :string
  attribute :first_name, :string
  attribute :last_name, :string

  before_validation :set_user_id, if: :email?

  delegate :name, to: :user
  delegate :upcoming_meeting, :next_meeting, to: :meeting_schedule

  def set_user_id
    existing_user = User.find_by(id: user_id)
    self.user = if existing_user.present?
      existing_user
    else
      User.invite!({email: email, first_name: first_name, last_name: last_name}, current_user) do |u|
        u.skip_invitation = true
      end
    end
  end
end
