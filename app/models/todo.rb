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

  ## Paper trail
  has_paper_trail only: [:status, :assign_id, :deadline], class_name: 'Event'
  has_many :events, as: :item, dependent: :destroy
  before_validation :set_update_event, on: :update
  after_create :set_object

  belongs_to :team
  belongs_to :project
  belongs_to :user
  belongs_to :assign_user, class_name: 'User', foreign_key: :assign_id
  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :title, :content, :project_id

  before_create :set_foreign_key

  def can_edit?(cuser)
    return true if user_id == cuser.id
    return true if assign_id == cuser.id
    return false
  end

  include AASM

  aasm column: :status, whiny_transitions: true do
    state :open, :initial => true
    state :running
    state :closed

    event :start do
      transitions from: :open, to: :running
      before do
        set_paper_trail_event
      end
    end

    event :stop do
      transitions from: :running, to: :open
      before do
        set_paper_trail_event
      end
    end

    event :close do
      transitions from: [:open, :running], to: :closed
      before do
        set_paper_trail_event
      end
    end

    event :reopen do
      transitions from: :closed, to: :open
      before do
        set_paper_trail_event
      end
    end
  end

private

  def set_update_event
    %w[assign_id deadline].any? do |attr|
      if self.send("#{attr}_changed?")
        self.paper_trail_event = "#{attr}_update" 
      end
    end
    return true
  end

  def set_paper_trail_event
    self.paper_trail_event = aasm.current_event
    puts "paper_trail_event: #{paper_trail_event}"
  end

  def set_foreign_key
    self.team_id = self.project.team_id
  end
end
