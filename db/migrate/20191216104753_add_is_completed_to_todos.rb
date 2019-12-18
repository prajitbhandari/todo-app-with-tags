class AddIsCompletedToTodos < ActiveRecord::Migration[5.2]
  def change
    add_column :todos, :isCompleted, :boolean
  end
end
