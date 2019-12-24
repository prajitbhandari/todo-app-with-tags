class TodosChangeColumnType < ActiveRecord::Migration[5.2]
  def up
    change_column :todos, :isCompleted, :boolean, default: false
  end

  def down
    change_column :todos, :isCompleted, :boolean, default: nil
  end
end
