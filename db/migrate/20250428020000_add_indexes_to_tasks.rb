class AddIndexesToTasks < ActiveRecord::Migration[7.0]
  def change
    add_index :tasks, :status
    add_index :tasks, :due_date
    add_index :tasks, :created_at
    add_index :tasks, :title
    add_index :tags, :name, unique: true
  end
end
