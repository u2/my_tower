class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.integer :team_id
      t.integer :project_id
      t.string :title
      t.integer :user_id
      t.text :content
      t.string :status
      t.integer :assign_id
      t.date :deadline

      t.timestamps
    end
  end
end
