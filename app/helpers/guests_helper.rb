module GuestsHelper
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        # reload guest_user to prevent caching problems before destruction
        guest_user(with_retry = false).try(:reload).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end
  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_user_id] = nil
     guest_user if with_retry
  end

  private

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    guest_cart = guest_user.orders.where(cart: true).first
    current_user_cart = current_user.orders.where(cart: true).first_or_create
    if guest_cart
      guest_cart.line_items.each do |l|
        user_cart_line_item = current_user_cart.line_items.find_or_initialize_by(variant_id: l.variant_id)
        if user_cart_line_item.quantity&.to_i + l.quantity&.to_i > 5 
          user_cart_line_item.update(quantity: 5)
        else
          user_cart_line_item.quantity = user_cart_line_item.quantity + l.quantity
          user_cart_line_item.save
        end
      end
    end
  end

  def create_guest_user
    u = User.new(:name => "guest", :email => "guest_#{Time.now.to_i}#{rand(100)}@example.com", guest: true)
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end
end
