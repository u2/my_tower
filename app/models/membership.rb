# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  team_id    :integer
#  role       :integer
#  created_at :datetime
#  updated_at :datetime
#

class Membership < ActiveRecord::Base

  enum role: { visitor: 10, participant: 20, admin: 30, super_admin: 40 }

  MANAGERS = %w{ admin super_admin }

  belongs_to :team
  belongs_to :user

  validates_presence_of :user_id
  validates_uniqueness_of :user_id, scope: :team_id
  validate :must_has_admin?, on: :update

  before_destroy :check_only_super_admin?, if: Proc.new{|membership| membership.admin? }
  before_update :update_accesses

  def admin?
    Membership::MANAGERS.include?(self.role)
  end

private

  def update_accesses
    if self.role_changed?
      if Membership::MANAGERS.include?(self.role_was) != Membership::MANAGERS.include?(self.role)
        access_role = self.admin? ? Access.roles[:admin] : Access.roles[:participant]
        Access.where(user_id: user_id, team_id: team_id).update_all(role: access_role)
      end
    end
  end

  def must_has_admin?
    if self.role_was == "super_admin"
      errors.add(:role, '至少有一个超级管理员') unless check_only_super_admin?
    end
  end

  def check_only_super_admin?
    Membership.where(team_id: self.team_id).where.not(user_id: self.user_id).where(role: Membership.roles[:admin]).exists?
  end
end
