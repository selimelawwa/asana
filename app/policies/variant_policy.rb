class VariantPolicy < ApplicationPolicy
  def index?
    user && user.admin?
  end
  def update_stock?
    user && user.admin?
  end
end
