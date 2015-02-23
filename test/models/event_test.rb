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

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
