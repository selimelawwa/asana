class CityPolicy < ApplicationPolicy
  def index?
    user && user.admin?
  end
  def create?
    user && user.admin?
  end
  def update?
    user && user.admin?
  end
end
