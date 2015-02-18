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

class Todo < ActiveRecord::Base

  belongs_to :team
  belongs_to :project
  belongs_to :user
  belongs_to :assign_user, class_name: 'User'

  validates_presence_of :title, :content, :project_id

  before_create :set_foreign_key

  include AASM

  aasm column: :status, whiny_transitions: true do
    state :open, :initial => true
    state :running
    state :closed

    event :start do
      transitions from: :open, to: :running
    end

    event :stop do
      transitions from: :running, to: :open
    end

    event :close do
      transitions from: [:open, :running], to: :closed
    end

    event :reopen do
      transitions from: :closed, to: :open
    end

  end

  private

    def set_foreign_key
      self.team_id = self.project.team_id
    end

end
