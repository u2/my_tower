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

require 'rails_helper'

RSpec.describe Membership, :type => :model do
  describe "must has super admin member" do
    it "cannot delete only admin member" do
      user = create(:user)
      team = Team.create!(name: 'tower', user_id: user.id)
      membership = team.memberships.first
      expect(membership.destroy).to be false
    end

    it "cannot change the only super admin role" do
      user = create(:user)
      team = Team.create!(user_id: user.id, name: 'tower')
      membership = team.memberships.first
      expect(membership.update(role: Membership.roles[:visitor])).to be false
    end
  end
end
