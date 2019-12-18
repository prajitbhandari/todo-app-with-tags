require 'rails_helper'

RSpec.describe 'Creating a Todo Item', type: :feature do
  scenario 'with valid inputs' do
    visit new_todo_path
    fill_in 'todo_item', with: 'Todo Item created'
    click_button 'Create Todo'
    visit todo_path
    expect(page).to have_text('Todo Item created')
  end
  scenario 'invalid inputs' do
    visit new_todo_path
    fill_in 'todo_item', with: ''
    click_button 'Create Todo'
    # expect(page).to have_content("Item can't be blank")
  end
end