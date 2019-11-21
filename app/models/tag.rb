class Tag < ApplicationRecord
  has_and_belongs_to_many :todos
  # accepts_nested_attributes_for :todos, update_only: true
  validates :name, presence: true
end