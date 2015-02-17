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

require 'test_helper'

class AccessTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
