# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text
#  user_id          :integer
#  commentable_id   :integer
#  commentable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'rails_helper'

RSpec.describe Comment, :type => :model do
  before(:all) do
    @user = create(:user)
    @team = create(:team, user_id: @user.id)
    @project = create(:project, team_id: @team.id, user_id: @user.id)
    @owner = create(:user)
    @assign_user = create(:user)
    @todo = create(:todo, project_id: @project.id, user_id: @owner.id, assign_id: @assign_user.id) 

    @comment_user = create(:user)
    @comment = Comment.create(user_id: @comment_user.id, commentable_type: @todo.class.name, commentable_id: @todo.id, content: 'content')
  end

  describe "edit comment" do
    it "comment_user can edit" do
      expect(@comment.can_edit?(@comment_user)).to be true
    end

    it "others can not edit" do
      expect(@comment.can_edit?(@user)).to be false
    end
  end

  describe "comment event" do

    before(:each) do
      @comment = Comment.create(user_id: @comment_user.id, commentable_type: @todo.class.name, commentable_id: @todo.id, content: 'content')
      @event = @comment.reload.events.order(id: :desc).first
    end

    it "commentable", :versioning => true do
      expect(@event.commentable).to eq(@todo)
      expect(@event.commentable_id).to eq(@comment.commentable_id)
    end

    it "event item", :versioning => true do
      expect(@event.event_item_type).to eq(@comment.commentable_type)
      expect(@event.event_item_id).to eq(@comment.commentable_id)
    end

    it "has object attribute", :versioning => true do
      expect(@event.object["id"]).to eq(@comment.id)
    end
  end
end
