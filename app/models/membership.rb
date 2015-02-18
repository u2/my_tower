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

  enum role: { visitor: 10, participant: 20, admin: 30 }

  belongs_to :team
  belongs_to :user

  validates_presence_of :user_id
  validates_uniqueness_of :user_id, scope: :team_id

  def admin?
    self.role == "admin"
  end

  before_destroy :check_only_admin?, if: Proc.new{|membership| membership.admin? }
  validate :must_has_admin?, on: :update

  private

    def must_has_admin?
      if self.role_change[0] == "admin"
        errors.add(:role, '至少有一个管理员') unless check_only_admin?
      end
    end

    def check_only_admin?
      Membership.where(team_id: self.team_id).where.not(user_id: self.user_id).where(role: Membership.roles[:admin]).exists?
    end

end
