class TagPolicy < ApplicationPolicy
  def create?
    user && user.admin?
  end
  def update?
    user && user.admin?
  end
  def destroy?
    user && user.admin?
  end
  def available_products?
    user && user.admin?
  end
  def assign_products?
    user && user.admin?
  end
  def assigned_products?
    user && user.admin?
  end
  def remove_products?
    user && user.admin?
  end
end
