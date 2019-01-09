class OrderPolicy < ApplicationPolicy
  def show?
    user && (user.admin? || user.id == order.user_id)
  end
end
