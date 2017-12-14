module User::RegistrationsHelper
  def sign_up_errors
    if @sign_up.errors.any?
      @sign_up.errors.inspect
    end
  end
end
