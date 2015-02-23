class AddIndexes < ActiveRecord::Migration
  def change
    add_index :memberships, :team_id

    add_index :projects, :team_id

    add_index :accesses, :user_id
    add_index :accesses, :team_id

    add_index :todos, :project_id

    add_index :events, :whodunnit_id
    add_index :events, :team_id
    add_index :events, :project_id
  end
end
