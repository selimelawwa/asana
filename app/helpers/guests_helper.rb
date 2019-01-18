module GuestsHelper
  def current_or_guest_user
    if current_user
      if cookies.signed[:guest_user_id] && cookies.signed[:guest_user_id] != current_user.id
        logging_in
        # reload guest_user to prevent caching problems before destruction
        guest_user(with_retry = false).try(:reload).try(:destroy)
        cookies.delete :guest_user_id
      end
      current_user
    else
      guest_user
    end
  end
  # find guest_user object associated with the saved cookie,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(cookies.signed[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if cookies.signed[:guest_user_id] invalid
    cookies.delete :guest_user_id
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
        current_user_cart_line_item = current_user_cart.line_items.find_or_initialize_by(variant_id: l.variant_id)
        if current_user_cart_line_item.quantity&.to_i + l.quantity&.to_i > 5 
          current_user_cart_line_item.update(quantity: 5)
        else
          current_user_cart_line_item.quantity = current_user_cart_line_item.quantity + l.quantity
          current_user_cart_line_item.save
        end
      end
    end
  end

  def create_guest_user
    u = User.new(:name => "guest", :email => "guest_#{Time.now.to_i}#{rand(100)}@example.com", guest: true)
    u.save!(:validate => false)
    cookies.permanent[:guest_user_id] = u.id
    u
  end
end
