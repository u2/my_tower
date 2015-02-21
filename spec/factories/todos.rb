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

FactoryGirl.define do
  factory :todo do
    sequence(:title) { |n| "Todo#{n}" }
    content(:title) { |n| "Content#{n}" }
    association(:user)
    association(:team)
    association(:project)
    association(:assign_user)
  end
end
