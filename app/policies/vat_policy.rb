class VatPolicy < ApplicationPolicy
  def update?
    user && user.admin?
  end
end
