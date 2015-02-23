# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  whodunnit_id   :integer
#  team_id        :integer
#  project_id     :integer
#  whodunnit      :json
#  event          :string(255)
#  item_id        :integer
#  item_type      :string(255)
#  object         :json
#  object_changes :json
#  created_at     :datetime
#

class Event < PaperTrail::Version
  belongs_to :project
  belongs_to :item, polymorphic: true

  def assign_user_was
    @assign_user_was ||= User.find(self.changeset["assign_id"][0]) if self.changeset["assign_id"][0].present?
  end

  def assign_user
    @assign_user ||= User.find(self.changeset["assign_id"][1]) if self.changeset["assign_id"] && self.changeset["assign_id"][1].present?
  end

  def deadline_was
    @deadline_was ||= self.changeset["deadline"][0] if self.changeset["deadline"][0].present?
  end

  def deadline
    @deadline ||= self.changeset["deadline"][1] if self.changeset["deadline"][1].present?
  end

  def title
    commentable? ? commentable.title : self.object["title"]
  end

  def commentable?
    self.item_type == 'Comment'
  end

  def commentable_type
    @commentable_type ||=  case event
    when 'create'
      self.changeset["commentable_type"][1]
    end
  end

  def commentable_id
    @commentable_id ||=  case event
    when 'create'
      self.changeset["commentable_id"][1]
    end
  end

  def commentable
    commentable ||= case event
    when 'create'
      if self.changeset["commentable_type"] && self.changeset["commentable_id"]
        commentable_id = self.changeset["commentable_id"][1]
        commentable = commentable_type.constantize.find_by_id commentable_id
      end
    end
  end

  def event_item_type
    self.commentable? ? self.commentable_type : self.item_type
  end

  def event_item_id
    self.commentable? ? self.commentable_id : self.item_id
  end

end
