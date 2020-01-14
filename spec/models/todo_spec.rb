require 'rails_helper'
require 'support/database_cleaner'
RSpec.describe Todo, type: :model do
  context "when todo item is to be created" do
    it "should create todo item" do
      todo = Todo.new(item: "Todo item created!")
      todo.save
      expect(todo).to be_valid
    end
    it "should not have todo item to be nil or empty" do
      todo = Todo.new(item: nil)
      todo.save
      expect(todo).to_not be_valid
      expect(todo.errors.full_messages).to eq(["Item can't be blank"])
    end

    #it "is not valid without a created_date" do
    #  todo = Todo.new
    #  todo.item = "Todo Item "
    #  expect(todo.valid?).to be false
    #  expect(todo.errors.keys).to eq [:created_at]
    #  expect(todo.errors.full_messages).to eq "Todo Item created at must be present"
    #end
  end

  context "When todo item is to be displayed" do
    it "should find out the valid todo item" do
      todo = Todo.with_deleted.find_by(id: 1)
      expect(todo).to eq(nil)
    end
    it "should not find the nil or invalid todo item" do
      todo = Todo.with_deleted.find_by(id: 1234)
      expect(todo).to eq(nil)
    end
  end

  context "when todo item is to be updated" do
    let(:subject_todo) { FactoryBot.create(:todo, item: "Todo Item!!! ")}
    before do
      subject_todo
    end
    it "should update the todo item" do
      subject_todo.item =  "updated Todo Item!!"
      subject_todo.save
      expect(subject_todo).to be_valid
    end
    it "should update the todo item Completion" do
      subject_todo.isCompleted = true
      subject_todo.save
      expect(subject_todo).to be_valid
    end

    it "should not update the todo item to be nil" do
      subject_todo.item = nil
      subject_todo.save
      expect(subject_todo).to_not be_valid
    end

    it "should not update the todo completion  to be nil" do
      subject_todo.isCompleted = nil
      subject_todo.save
      expect(subject_todo).to_not be_valid
    end
  end

  context "when todo item is to be destroyed" do
    let(:subject_todo) { FactoryBot.create(:todo, item: "Todo Item!!!")}
    before do
      subject_todo
    end
    it "should destroy the todo item " do
      subject_todo.destroy
      expect(subject_todo.deleted_at).to_not  be nil
      expect(subject_todo.deleted_at).to be_kind_of(ActiveSupport::TimeWithZone)
    end
  end

  context "when todo item is to be recovered" do
    let(:subject_todo) { FactoryBot.create(:todo, item: "Todo Item!!! ")}
    before do
      subject_todo.destroy
    end
    it "should recover destroyed todo item" do
      subject_todo.restore
      expect(subject_todo.deleted_at).to eq nil
    end
  end

  context "when todo item is to be purged" do
    let(:subject_todo) { FactoryBot.create(:todo, item: "Todo Item!!! ")}
    before do
      subject_todo.destroy
    end
    it "should purge the todo item" do
      subject_todo.really_destroy!
      expect{Todo.with_deleted.find(subject_todo.id)}.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
































































#require 'rails_helper'
#
#RSpec.describe Todo, type: :model do
#  context "when todo is to be created" do
#    it "is not valid without todo item " do
#      todo = Todo.new(item: nil)
#      todo.save
#      expect(todo.errors.keys).to include(:item)
#      expect(todo.errors.full_messages).to eq(["Item can't be blank"])
#    end
#    it "is valid to be created" do
#      todo = Todo.new(item: "Some text for todo item")
#      todo.save
#      expect(todo).to be_valid, "Todo item is valid"
#    end
#  end
#end