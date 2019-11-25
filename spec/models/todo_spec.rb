require 'rails_helper'

RSpec.describe Todo, type: :model do
  context "when todo is to be created" do
    it "is not valid without todo item " do
      todo = Todo.new(item: nil)
      expect(todo).not_to be_nil
    end
    it "is valid to be created" do
      todo = Todo.new(item: "Some text for todo item")
      todo.save
      expect(todo).to be_valid
    end
  end
end





