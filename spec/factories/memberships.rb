# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  team_id    :integer
#  role       :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :membership do
    association(:user)
    association(:team)
    role { Membership.roles.keys.sample }
  end
end
