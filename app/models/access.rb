# == Schema Information
#
# Table name: accesses
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  team_id    :integer
#  role       :integer
#  created_at :datetime
#  updated_at :datetime
#

class Access < ActiveRecord::Base

  enum role: { participant: 20, admin: 30 }

  belongs_to :project
  belongs_to :team
  belongs_to :user

  validates_presence_of :user_id
  validates_uniqueness_of :user_id, scope: :project_id
  validate :must_has_admin?, on: :update

  before_create :set_team_id, :set_role
  before_destroy :check_only_admin?, if: Proc.new{|access| access.admin? }

private

  def set_team_id
    if self.project_id
      self.team_id = self.project.team_id
    end
  end

  def set_role
    unless role
      self.role = self.team.admin?(user) ? 'admin' : 'participant'
    end
  end

  def must_has_admin?
    if self.role_change[0] == "admin"
      errors.add(:role, '至少有一个管理员') unless check_only_admin?
    end
  end

  def check_only_admin?
    Access.where(project_id: self.project_id).where.not(user_id: self.user_id).where(role: Access.roles[:admin]).exists?
  end
end
