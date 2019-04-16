class EmailsMailer < ApplicationMailer
  default from: 'Asana Athleisure'
  # default from: 'contact@asanaathleisure.com'
  
  def new_user(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Asana Athleisure!')
  end

  def new_order(user,order)
      @user = user
      @order = order
      mail(to: @user.email, subject: 'Order Confirmed!')
  end

  def confirm_order_admin_email(user,order)
    @user = user
    @order = order
    mail(to:  "contact@asanaathleisure.com", subject: 'New Order!')
  end

  def update_password(user)
    @user = user
    mail(to:  @user.email, subject: 'Password Updated!')
  end
end
