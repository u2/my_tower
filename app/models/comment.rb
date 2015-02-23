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

class Comment < ActiveRecord::Base

  ## Paper trail
  has_paper_trail on: [:create], class_name: 'Event'
  has_many :events, as: :item, dependent: :destroy
  after_create :set_object

  belongs_to :commentable, polymorphic: true
  delegate :team_id, :project_id, to: :commentable
  belongs_to :user

  validates_presence_of :content

  def can_edit?(cuser)
    user_id == cuser.id
  end
end
