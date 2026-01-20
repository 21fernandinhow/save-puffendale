class DeviseMailer < Devise::Mailer
    default from: "onboarding@resend.dev"
    layout false
  
    def reset_password_instructions(record, token, opts = {})
        
        reset_url = "#{Rails.application.routes.url_helpers.edit_user_password_url(
            reset_password_token: token,
            host: Rails.application.config.action_mailer.default_url_options[:host],
            protocol: Rails.application.config.action_mailer.default_url_options[:protocol]
        )}"
  
        Resend::Emails.send(
            from: default_params[:from],
            to: record.email,
            subject: "Redefinição de senha",
            html: <<~HTML
            <p>Olá #{record.email},</p>
            <p>Você solicitou a redefinição da sua senha.</p>
            <p>
                <a href="#{reset_url}">Clique aqui para redefinir sua senha</a>
            </p>
            <p>Se você não solicitou isso, ignore este email.</p>
            HTML
        )

    end
end