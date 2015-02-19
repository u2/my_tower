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

  describe "only admin/participant member project" do
    it "only member can create project" do
      member = create(:user)
      project = @team.projects.new(name: 'project', user_id: member.id)
      expect(project.save).to be false
    end

    it "visitor member can not create project" do
      visitor = create(:user)
      @team.memberships.create!(user_id: visitor.id, role: Membership.roles[:visitor])
      project = @team.projects.new(name: 'project', user_id: visitor.id)
      expect(project.save).to be false
    end

    it "admin member can create project" do
      admin = create(:user)
      @team.memberships.create!(user_id: admin.id, role: Membership.roles[:admin])
      project = @team.projects.new(name: 'project', user_id: admin.id)
      expect(project.save).to be true
    end
  end
end
