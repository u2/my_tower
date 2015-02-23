# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  team_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Project < ActiveRecord::Base

  attr_accessor :user_id

  belongs_to :team
  has_many :accesses, dependent: :destroy
  has_many :users, through: :accesses
  has_many :todos, dependent: :destroy
  has_many :events, dependent: :destroy

  validates_presence_of :user_id
  after_create :create_admin_access

  validate :must_be_member, :can_not_be_visitor, on: :create

  def admin?(user)
    self.accesses.where(user_id: user.id, role: Access.roles[:admin]).exists?
  end

  def member?(user)
    self.accesses.where(user_id: user.id).exists?
  end

  def user
    @user ||= User.find(user_id)
  end

private

  def must_be_member
    errors.add(:base, '非团队成员不能创建项目') unless team.member?(user)
  end

  def can_not_be_visitor
    errors.add(:base, '访问者不能创建项目') if team.visitor?(user)
  end

  def create_admin_access
    self.accesses.create!(user_id: self.user_id, role: Access.roles[:admin])
  end
end
