class SignUp
  include ActiveModel::Model
  attr_reader :user, :organization
  attr_accessor :organization_name, :time_zone, :first_name, :last_name, :email, :password, :password_confirmation
  validates :organization_name, :first_name, :last_name, :email, :password, :password_confirmation, presence: true

  def self.authentication_keys
    [:email, :first_name, :last_name, :password, :password_confirmation, :organization_name, :time_zone]
  end

  def save
    #Validate sign_up object
    return false unless valid?
    ActiveRecord::Base.transaction do
      delegate_attributes_for_organization
      delegate_attributes_for_user
      persist!
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    false
  end

  private

  def delegate_attributes_for_organization
    @organization = Organization.new do |organization|
      organization.name = organization_name
      organization.time_zone = time_zone
    end
  end

  def delegate_attributes_for_user
    @user = User.new do |user|
      user.first_name = first_name
      user.last_name = last_name
      user.email = email
      user.password = password
      user.password_confirmation = password_confirmation
      user.account_administrator = true
    end
  end

  def delegate_errors_for_organization
    @organization.valid?
    errors.add(:organization_name, @organization.errors[:name].first) if @organization.errors[:name].present?
  end

  def delegate_errors_for_user
    @user.valid?
    errors.add(:email, @user.errors[:email].first) if @user.errors[:email].present?
    errors.add(:password, @user.errors[:password].first) if @user.errors[:password].present?
    errors.add(:password_confirmation, @user.errors[:password_confirmation].first) if @user.errors[:password_confirmation].present?
  end

  def persist!
    delegate_errors_for_organization
    @organization.save!
    @user.organization = @organization
    persist_user!
  end

  def persist_user!
    delegate_errors_for_user
    @user.save!
  end
end
