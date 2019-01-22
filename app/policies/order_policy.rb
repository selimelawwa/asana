class OrderPolicy < ApplicationPolicy
  def show?
    user && (user.admin? || user.id == record.user_id)
  end
  def cart?
    user && (user.id == record.user_id)
  end
  def select_address?
    user && (user.id == record.user_id)
  end
  def assign_address?
    user && (user.id == record.user_id)
  end
  def create_address?
    user && (user.id == record.user_id)
  end
  def confirm_details?
    user && (user.id == record.user_id)
  end
  def confirm_order?
    user && (user.id == record.user_id)
  end
end
