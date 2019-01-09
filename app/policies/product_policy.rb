class ProductPolicy < ApplicationPolicy
  def create?
    user && user.admin?
  end
  def update?
    user && user.admin?
  end
  def destroy?
    user && user.admin?
  end
  def list?
    user && user.admin?
  end
end