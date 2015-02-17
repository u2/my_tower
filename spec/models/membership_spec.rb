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

  it "cannot delete only admin member" do
    user = create(:user)
    team = Team.create(user_id: user.id, name: 'tower')
    membership = Membership.last
    expect(membership.destroy).to be false

    user2 = create(:user)
    membership2 = Membership.create(user_id: user.id, role: Membership.roles[:admin])
    expect(membership2.destroy).to eq(membership2)
  end

end
