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

require 'rails_helper'

RSpec.describe Access, :type => :model do

  describe "must has admin member" do
    it "cannot delete only admin access" do
      user = create(:user)
      team = Team.create(name: 'tower', user_id: user.id)
      project = team.projects.create!(name: 'project', user_id: user.id) 
      access = project.accesses.first
      expect(access.destroy).to be false

      user2 = create(:user)
      access2 = project.accesses.create(user_id: user2.id, role: Access.roles[:admin])
      expect(access2.destroy).to eq(access2)
    end

    it "cannot change the only admin role" do
      user = create(:user)
      team = Team.create(name: 'tower', user_id: user.id)
      project = team.projects.create!(name: 'project', user_id: user.id)
      access = project.accesses.first
      expect(access.update(role: Access.roles[:visitor])).to be false
    end
  end

end
