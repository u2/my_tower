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

  enum role: { visitor: 10, admin: 30 }

  belongs_to :project
  belongs_to :team
  belongs_to :user

  validates_presence_of :user_id
  validates_uniqueness_of :user_id, scope: :project_id

  before_create :set_foreign_key
  before_destroy :check_only_admin?

  private

    def set_foreign_key
      self.team_id = self.project.team_id
    end

    def check_only_admin?
      Access.where(project_id: self.project_id).where.not(user_id: self.user_id).where(role: Access.roles[:admin]).exists?
    end

end
