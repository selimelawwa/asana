class OrderPolicy < ApplicationPolicy
  def show?
    user && (user.admin? || user.id == record.user_id)
  end
  def cart?
    user && (user.id == record.user_id)
  end
end
