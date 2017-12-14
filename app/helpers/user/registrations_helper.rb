module User::RegistrationsHelper
  def sign_up_errors
    if @sign_up.errors.any?
      messages = @sign_up.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
      sentence = I18n.t("errors.messages.not_saved",
        :count => @sign_up.errors.count,
        :resource => "account")

      html = <<-HTML
      <div class="alert alert-warning">
        <h2>#{sentence}</h2>
        <ul>#{messages}</ul>
      </div>
      HTML

      html.html_safe
    end
  end
end
