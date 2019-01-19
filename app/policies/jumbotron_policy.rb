class JumbotronPolicy < ApplicationPolicy
  def create?
    user && user.admin?
  end
  def update?
    user && user.admin?
  end
end
