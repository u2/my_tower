require 'rails_helper'

RSpec.describe Access, :type => :model do

  it "cannot delete only admin access" do
    user = create(:user)
    team = Team.create(user_id: user.id, name: 'tower')
    project = team.projects.create!(name: 'project', user_id: user.id) 
    access = project.accesses.first
    expect(access.destroy).to be false

    user2 = create(:user)
    access2 = Access.create(user_id: user2.id, role: Access.roles[:admin], project_id: project.id)
    expect(access2.destroy).to eq(access2)
  end

end
