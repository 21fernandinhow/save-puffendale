class DeviseMailer < Devise::Mailer
    default from: "onboarding@resend.dev"
    layout false
  
    def reset_password_instructions(record, token, opts = {})
        opts[:subject] = "Redefinição de senha"
        @token = token
    
        devise_mail(record, :reset_password_instructions, opts)
    end
end