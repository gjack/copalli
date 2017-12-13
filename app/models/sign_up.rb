class SignUp
  include ActiveModel::Model

  attr_reader :user, :organization
  attr_accessor :name, :time_zone, :first_name, :last_name, :email, :password, :password_confirmation

  validates :name, :first_name, :last_name, :email, :password, :password_confirmation, presence: true

  def save
    #Validate sign_up object
    return false unless valid?
    delegate_attributes_for_organization
    delegate_attributes_for_user
    persist!
    errors.any? ? false : true
  end

  private

  def delegate_attributes_for_organization
    @organization = Organization.new do |organization|
      organization.name = name,
      organization.time_zone = time_zone,
    end
  end

  def delegate_attributes_for_user
    @user = User.new do |user|
      user.first_name = first_name,
      user.last_name = last_name,
      user.email = email,
      user.password = password,
      user.password_confirmation = password_confirmation,
      user.account_administrator = true,
    end
  end

  def delegate_errors_for_organization
    errors.add(:organization_name, @organization.errors[:name]) if @organization.errors[:name].present?
  end

  def delegate_errors_for_user
    errors.add(:email, @user.errors[:email].first) if @user.errors[:email].present?
    errors.add(:password, @user.errors[:password].first) if @user.errors[:password].present?
  end

  def persist!
    persist_organization!
    persist_user!
  end

  def persist_organization!
    delegate_errors_for_organization
    if @organization.valid?
      @organization.save!
      @user.organization = @organization
    end
  end

  def persist_user!
    delegate_errors_for_user
    if @user.valid?
      @user.save!
    end
  end
end
