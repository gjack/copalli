class SignUpParameterSanitizer < Devise::ParameterSanitizer
  def initialize(*)
    super
    permit(
      :sign_up,
      keys: [
        :first_name,
        :last_name,
        :email,
        :password,
        :password_confirmation,
        :organization_name,
        :time_zone,
      ]
    )
  end
end
