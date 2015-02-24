# == Schema Information
#
# Table name: todos
#
#  id         :integer          not null, primary key
#  team_id    :integer
#  project_id :integer
#  title      :string(255)
#  user_id    :integer
#  content    :text
#  status     :string(255)
#  assign_id  :integer
#  deadline   :date
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Todo, :type => :model do

  before(:all) do
    @user = create(:user)
    @team = create(:team, user_id: @user.id)
    @project = create(:project, team_id: @team.id, user_id: @user.id)
    @owner = create(:user)
    @assign_user = create(:user)
    @todo = create(:todo, project_id: @project.id, user_id: @owner.id, assign_id: @assign_user.id) 
  end

  describe "only owner or assign_user member can edit todo" do
    it "owner can edit" do
      expect(@todo.can_edit?(@owner)).to be true
    end

    it "assign_user can edit" do
      expect(@todo.can_edit?(@user)).to be false
      expect(@todo.can_edit?(@assign_user)).to be true
    end

    it "uncorrelated user can not edit" do
      @uncorrelated = create(:user)
      expect(@todo.can_edit?(@uncorrelated)).to be false
    end
  end

  describe "generate event for aasm event" do

    before(:each) do
      @todo = create(:todo, project_id: @project.id, user_id: @owner.id, assign_id: @assign_user.id) 
      @create_event = @todo.reload.events.order(id: :desc).first
    end

    context "create event" do
      it "generate create event", :versioning => true do
        expect(@create_event.event).to eq('create')
      end

      it "has object attribute", :versioning => true do
        expect(@create_event.object["id"]).to eq(@todo.id)
      end
    end

    it "generate aasm event", :versioning => true do

      Todo.aasm.events.each do |key|
        eval %Q{
          @todo.#{key.name}!
          @#{key.name}_event = @todo.reload.events.order(id: :desc).first
        }
      end

      Todo.aasm.events.each do |key|
        expect(instance_variable_get("@#{key.name}_event").event).to eq("#{key.name}!")
      end

      expect(@start_event.event_item_type).to eq("Todo")
      expect(@start_event.event_item_id).to eq(@todo.id)
    end
  end

  describe "generate update events" do



    context "assign update" do

      before(:each) do
        @new_user = create(:user)
        @todo.update(assign_id: @new_user.id)
        @assign_event = @todo.reload.events.order(id: :desc).first
      end

      it "assign_id update", :versioning => true do
        expect(@assign_event.assign_user_was.id).to eq(@assign_user.id)
        expect(@assign_event.assign_user.id).to eq(@new_user.id)
        expect(@assign_event.event).to eq('assign_id_update')
      end

      it "assign event is not commentable", :versioning => true do
        expect(@assign_event.commentable).to be nil
        expect(@assign_event.commentable?).to be false
      end
    end

    context "deadline update" do
      let(:day) { Date.today + (-10..10).to_a.sample }

      it "deadline update", :versioning => true do
        @todo.update(deadline: day)
        @deadline_event = @todo.reload.events.order(id: :desc).first
        expect(@deadline_event.deadline_was).to be nil
        expect(@deadline_event.deadline).to eq(day.to_s)
        expect(@deadline_event.event).to eq('deadline_update')
      end  
    end
  end
end
