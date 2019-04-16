# Preview all emails at http://localhost:3000/rails/mailers/emails_mailer
class EmailsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/emails_mailer/new_user
  def new_user
    EmailsMailer.new_user
  end

  # Preview this email at http://localhost:3000/rails/mailers/emails_mailer/new_order
  def new_order
    EmailsMailer.new_order
  end

end
