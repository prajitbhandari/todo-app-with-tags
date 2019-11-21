require 'test_helper'

class TodoTest < ActiveSupport::TestCase
  test "todo should be created with a item" do
    todo = Todo.new
    todo.nil?
    assert_not todo.save
  end
end
