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

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
