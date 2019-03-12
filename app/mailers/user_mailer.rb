class UserMailer < ApplicationMailer
    default from: 'Asana Athleisure'

    def welcome_email(user)
        @user = user
        mail(to: @user.email, subject: 'Welcome to Asana Athleisure')
    end

    def confirm_order_user_email(user)
        @user = user
        mail(to: @user.email, subject: 'Order Confirmed')
    end

    def confirm_order_admin_email(user, order)
        @user = user
        @order = order
        mail(to: 'asana.athleisure2019@gmail.com', subject: 'New Order')
    end

end
