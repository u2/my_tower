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

  before_destroy :check_only_admin?

  private

    def check_only_admin?
      Membership.where(team_id: self.team_id).where.not(user_id: self.id).where(role: Membership.roles[:admin]).exists?
    end

end
