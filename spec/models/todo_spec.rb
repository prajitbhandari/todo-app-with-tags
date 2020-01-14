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
    let(:subject_tag) { FactoryBot.create(:tag, name: "Tag Name!!! ")}
    before do
      subject_todo
      subject_tag
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
    it "should update associated todo tags" do
      subject_todo.tag_ids = subject_tag.id
      expect(subject_todo).to be_valid
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
    it "should not destroy nil or empty todo item " do
      expect{Todo.with_deleted.find(123).destroy!}.to raise_error ActiveRecord::RecordNotFound
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
    it "should not recover nil or empty todo item " do
      expect{Todo.with_deleted.find(123).restore}.to raise_error ActiveRecord::RecordNotFound
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
    it "should not purge nil or empty todo item " do
      expect{Todo.with_deleted.find(123).really_destroy!}.to raise_error ActiveRecord::RecordNotFound
    end
  end

  context "when association is to be done" do
    let(:subject_tag){FactoryBot.create(:tag, name: "Tag created!")}
    before do
      subject_tag
    end
    it "should have associcated todo tags" do
      todo = Todo.new(item: "Todo Item !!!", tag_ids: subject_tag.id)
      todo.save
      expect(todo).to be_valid
    end
  end
end

