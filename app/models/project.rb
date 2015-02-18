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
  has_many :todos, dependent: :destroy

  validates_presence_of :user_id
  after_create :create_admin_access

  def admin?(user)
    self.accesses.where(user_id: user.id, role: Access.roles[:admin]).exists?
  end

  def member?(user)
    self.accesses.where(user_id: user_id).exists?
  end

  private

    def create_admin_access
      self.accesses.create!(user_id: self.user_id, role: Access.roles[:admin])
    end

end
