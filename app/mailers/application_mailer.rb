class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_USERNAME")
  layout "mailer"
end
