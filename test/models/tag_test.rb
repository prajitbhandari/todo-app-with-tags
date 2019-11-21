require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test "tag  should be created with a tag name" do
    tag = Tag.new
    tag.nil?
    assert_not tag.save, "Cannot save a empty tag name"
  end
end
