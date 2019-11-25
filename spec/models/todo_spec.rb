require 'rails_helper'

RSpec.describe Todo, type: :model do
  context "when todo is to be created" do
    it "is not valid without todo item " do
      todo = Todo.new(item: nil)
      todo.save
      expect(todo.errors.keys).to include(:item)
      expect(todo.errors.full_messages).to eq(["Item can't be blank"])
    end
    it "is valid to be created" do
      todo = Todo.new(item: "Some text for todo item")
      todo.save
      expect(todo).to be_valid, "Todo item is valid"
    end
  end
end
