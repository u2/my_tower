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

  describe "access accroding to membership" do
    before do
      @super_admin_user = create(:user)
      @team = Team.create!(name: 'tower', user_id: @super_admin_user.id)

      @owner = create(:user)
      @team.memberships.create!(user_id: @owner.id, role: Membership.roles[:participant])

      @project = Project.create!(name: 'project', user_id: @owner.id, team_id: @team.id)

      @visitor = create(:user)
      @team.memberships.create!(user_id: @visitor.id, role: Membership.roles[:visitor])

      @participant = create(:user)
      @team.memberships.create!(user_id: @participant.id, role: Membership.roles[:participant])

      @admin = create(:user)
      @team.memberships.create!(user_id: @admin.id, role: Membership.roles[:admin])

      @project.users << @visitor
      @project.users << @participant
      @project.users << @admin
      @project.users << @super_admin_user

      @project.save!

      @project.reload
    end

    it "project owner has admin access" do
      expect(@project.admin?(@owner)).to be true
    end

    it "admin member has admin access" do
      expect(@project.admin?(@admin)).to be true
      expect(@project.admin?(@super_admin_user)).to be true
    end

    it "participant and visitor member has participant access" do
      expect(@project.admin?(@participant)).to be false
      expect(@project.member?(@participant)).to be true

      expect(@project.admin?(@visitor)).to be false
      expect(@project.member?(@visitor)).to be true
    end

    it "participant access change to admin access" do
      participant_membership = @team.memberships.where(user_id: @participant.id).first
      participant_membership.update!(role: Membership.roles[:admin])

      @project.reload
      expect(@project.admin?(@participant)).to be true
    end

    it "admin access change to participant access" do
      admin_membership = @team.memberships.where(user_id: @admin.id).first
      admin_membership.update!(role: Membership.roles[:visitor])

      @project.reload
      expect(@project.admin?(@admin)).to be false
      expect(@project.member?(@admin)).to be true
    end
  end
end
