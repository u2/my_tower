# == Schema Information
#
# Table name: event_associations
#
#  id               :integer          not null, primary key
#  event_id         :integer
#  foreign_key_name :string(255)      not null
#  foreign_key_id   :integer
#

require 'test_helper'

class EventAssociationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
