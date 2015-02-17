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

require 'rails_helper'

RSpec.describe Project, :type => :model do

  before do
    @user = create(:user)
    @team = Team.create(user_id: @user.id, name: 'tower')
  end

  it "created with admin access" do
    project = @team.projects.create!(name: 'project', user_id: @user.id)
    access = @team.projects.last.accesses.first

    expect(access.admin?).to be true
    expect(access.project).to eq(project)
    expect(access.user_id).to eq(@user.id)
  end
end
