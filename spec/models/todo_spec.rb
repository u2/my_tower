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

require 'rails_helper'

RSpec.describe Todo, :type => :model do

  describe "only owner or assign_user member can edit todo" do
    it "owner can edit" do
      
    end
  end
end
