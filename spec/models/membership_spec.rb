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

  describe "must has admin member" do
    it "cannot delete only admin member" do
      user = create(:user)
      team = Team.create!(name: 'tower', user_id: user.id)
      membership = team.memberships.first
      expect(membership.destroy).to be false

      user2 = create(:user)
      membership2 = team.memberships.create!(user_id: user2.id, role: Membership.roles[:admin])
      expect(membership2.destroy).to eq(membership2)
    end

    it "cannot change the only admin role" do
      user = create(:user)
      team = Team.create!(user_id: user.id, name: 'tower')
      membership = team.memberships.first
      expect(membership.update(role: Membership.roles[:visitor])).to be false
    end
  end

end
