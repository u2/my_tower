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

# TODO: 只能`bundle exec rspec spec/models/todo_spec.rb`，当`bundle exec rspec .`会报错
RSpec.describe Todo, :type => :model do

  before(:all) do
    @user = create(:user)
    @team = create(:team, user_id: @user.id)
    @project = create(:project, team_id: @team.id, user_id: @user.id)
    @owner = create(:user)
    @assign_user = create(:user)
    @todo = create(:todo, project_id: @project.id, user_id: @owner.id, assign_id: @assign_user.id) 

    @create_event = @todo.reload.events.order(id: :desc).first

    # paper_trail只能在before中使用，paper_trail的bug
    Todo.aasm.events.each do |key|
      eval %Q{
        @todo.#{key.name}!
        @#{key.name}_event = @todo.reload.events.order(id: :desc).first
      }
    end

    @todo.update(assign_id: @user.id)
    @assign_event = @todo.reload.events.order(id: :desc).first

    @day = Date.today

    @todo.update(deadline: @day)
    @deadline_event = @todo.reload.events.order(id: :desc).first
  end

  describe "only owner or assign_user member can edit todo" do
    it "owner can edit" do
      expect(@todo.can_edit?(@owner)).to be true
    end

    it "assign_user can edit" do
      expect(@todo.can_edit?(@user)).to be true
      expect(@todo.can_edit?(@assign_user)).to be false
    end

    it "uncorrelated user can not edit" do
      @uncorrelated = create(:user)
      expect(@todo.can_edit?(@uncorrelated)).to be false
    end
  end

  describe "generate event for aasm event" do
    context "create event" do
      it "generate create event" do
        expect(@create_event.event).to eq('create')
      end

      it "has object attribute" do
        expect(@create_event.object["id"]).to eq(@todo.id)
      end
    end

    it "generate aasm event" do
      Todo.aasm.events.each do |key|
        expect(instance_variable_get("@#{key.name}_event").event).to eq("#{key.name}!")
      end
    end
  end

  describe "generate update events" do
    it "assign_id update" do
      expect(@assign_event.assign_user_was.id).to eq(@assign_user.id)
      expect(@assign_event.assign_user.id).to eq(@user.id)
      expect(@assign_event.event).to eq('assign_id_update')
    end

    it "deadline update" do
      expect(@deadline_event.deadline_was).to be nil
      expect(@deadline_event.deadline).to eq(@day.to_s)
      expect(@deadline_event.event).to eq('deadline_update')
    end
  end

  describe "event attributes" do

    it "event commentable" do
      expect(@deadline_event.commentable).to be nil
      expect(@assign_event.commentable?).to be false
    end

    it "event type" do
      expect(@create_event.event_item_type).to eq("Todo")
      expect(@start_event.event_item_id).to eq(@todo.id)
    end
  end
end
