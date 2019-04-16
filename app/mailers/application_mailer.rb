class ApplicationMailer < ActionMailer::Base
  default from: 'Asana Athleisure'
  # default from: 'contact@asanaathleisure.com'
  layout 'mailer'
end
