# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Team, :type => :model do

  it "created with admin membership" do
    user = create(:user)
    team = Team.create(user_id: user.id, name: 'tower')
    membership = Membership.last
    expect(membership.admin?).to be true
    expect(membership.team_id).to eq(team.id)
    expect(membership.user_id).to eq(user.id)
  end

end
