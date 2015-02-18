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

require 'test_helper'

class TodoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
