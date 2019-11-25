require 'rails_helper'

RSpec.describe Tag, type: :model do
  context "when tag is to be created" do
    it 'is not valid without tag name' do
      tag = Tag.new(name: nil)
      tag.valid?
      expect(tag.errors[:name]).to include("can't be blank")
    end
    it "is valid with tag name" do
      tag = Tag.new(name: "Enter some tag name")
      tag.save
      expect(tag).to be_valid, "Tag name is valid"
    end
  end
end
