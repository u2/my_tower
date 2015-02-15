# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Team < ActiveRecord::Base

  attr_accessor :user_id

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  validates_presence_of :user_id
  after_create :create_admin_member

  def admin?(user)
    self.memberships.where(user_id: user.id, role: Membership.roles[:admin]).exists?
  end

  def member?(user)
    self.memberships.where(user_id: user_id).exists?
  end

  private

  def create_admin_member
    self.memberships.create!(user_id: self.user_id, role: Membership.roles[:admin])
  end

end
