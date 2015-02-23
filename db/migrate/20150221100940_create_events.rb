class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :whodunnit_id
      t.integer :team_id
      t.integer :project_id
      t.json  :whodunnit
      t.string  :event
      t.references :item, polymorphic: true, index: true
      t.json    :object
      t.json    :object_changes
      t.datetime :created_at
    end
  end
end
