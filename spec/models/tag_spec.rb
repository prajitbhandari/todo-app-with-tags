require 'rails_helper'

RSpec.describe Tag, type: :model do
  context "when tag is to be created" do
    it 'is not valid without tag name' do
      tag = Tag.new(name: nil)
      expect(tag).not_to be_nil
    end
    it "is valid with tag name" do
      tag = Tag.new(name: "Enter some tag name")
      tag.save
      expect(tag).to be_valid
    end
  end
end
