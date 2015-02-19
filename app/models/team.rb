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
  has_many :projects, dependent: :destroy

  validates_presence_of :user_id
  after_create :create_super_admin_member

  Membership.roles.keys.each do |role|
    define_method "#{role}?" do |user|
      (membership = self.memberships.where(user_id: user.id).first) && membership.send("#{role}?")
    end
  end

  def member?(user)
    self.memberships.where(user_id: user.id).exists?
  end

private

  def create_super_admin_member
    self.memberships.create!(user_id: self.user_id, role: Membership.roles[:super_admin])
  end
end
