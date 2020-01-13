require 'rails_helper'
require 'support/database_cleaner'
require 'support/factory_bot_rails'

RSpec.describe 'Todo App Crud Operation',js: true do

  context 'when todo item is to be created' do
    it 'should create todo-item' do
      visit root_path
      visit new_todo_path
      new_todo_item_name = Faker::Food.dish
      fill_in 'todo_item', with: new_todo_item_name
      click_button 'Create Todo'
      visit todos_path
      sleep 1
      new_todo_item = Todo.with_deleted.last
      within "tr#todo_#{new_todo_item.id}" do
        expect(page).to have_content(new_todo_item.id)
        expect(page).to have_content(new_todo_item.item)
        expect(page).to have_content('Mark as completed')
        expect(page).to have_link('Show')
        expect(page).to have_link('Edit')
        expect(page).to have_link('Destroy')
      end
      #sleep 1
      expect { Todo.create(item: new_todo_item_name ) }.to change { Todo.count }.by(1)
    end
  end

  context 'when todo item is to be marked as complete' do
    let(:subject_todo) { FactoryBot.create(:todo, item: "Item to be marked as completed!") }
    before do
      subject_todo
    end
    it 'should mark the todo item' do
      visit root_path
      within "tr#todo_#{subject_todo.id}" do
        find('.markItem').click
      end
      sleep 2
      page.driver.browser.switch_to.alert.accept
      sleep 2
      within "tr#todo_#{subject_todo.id}" do
        expect(page.find("#item#{subject_todo.id}").style('color').to_s).to eq("{\"color\"=>\"rgba(0, 128, 0, 1)\"}")
      end
      sleep 1
      expect(subject_todo.reload.isCompleted).to be true
    end
  end

  context 'when specific todo item is to be displayed' do
    let(:subject_todo) { FactoryBot.create(:todo, item: "Item to be marked as completed!") }
    let(:subject_todo_tags) { subject_todo.tags.all.each { |tag| tag.name } }
    before do
      subject_todo
      subject_todo_tags
    end
    it 'should show indiviual item detail' do
      visit root_path
      within "tr#todo_#{subject_todo.id}" do
        click_on "Show"
      end
      visit todo_path(subject_todo)
      sleep 1
      within('strong') do
        expect(page).to have_content('Item:')
      end
      expect(page).to have_content(subject_todo.item)
      expect(page).to have_link("Edit")
      expect(page).to have_link("Back")
      expect(page).to have_content("The checked Tags are:")
      expect(page).to have_content(subject_todo_tags) if subject_todo_tags.present?
    end
  end

  context 'when todo item is to be edited' do
    let(:subject_todo) { FactoryBot.create(:todo, item: "Item to be marked as completed!") }
    let(:subject_tag ) { 5.times{ FactoryBot.create(:tag, name: "Tag #{i}" )}}
    before do
      subject_todo
      subject_tag
    end
    it 'should update the indiviual item ' do
      visit root_path
      within "tr#todo_#{subject_todo.id}" do
        click_on "Edit"
      end
      sleep 1
      visit  edit_todo_path(subject_todo.id)
      debugger
      updated_item = Faker::Food.dish
      fill_in('todo_item', :with => updated_item)
      # Todo with tags associated with it

      click_on "Update Todo"
      sleep 2
      visit subject_todo
      visit todos_path
      within "tr#todo_#{subject_todo.id}" do
        expect(page.find("#item#{subject_todo.id}").text).to eq(updated_item)
      end
      sleep 2
      expect(subject_todo.reload.item).to eq(updated_item)
    end
  end

  context 'when todo item is to be deleted' do
    let(:subject_todo) { FactoryBot.create(:todo, item: "Item to be marked as completed!") }
    before do
      subject_todo
    end
    it 'should soft-delete' do
      visit root_path
      within "tr#todo_#{subject_todo.id}" do
        click_on "Destroy"
      end
      sleep 1
      #page.driver.browser.switch_to.alert.accept
      click_button 'Ok'
      sleep 1
      click_button 'OK'
      within "tr#todo_#{subject_todo.id}" do
        expect(page).to have_no_link('Destroy') #checking for front end section
        expect(page).to have_link('Recover')
        expect(page).to have_link('Purge')
      end
      expect(subject_todo.reload.deleted_at).not_to be nil
      expect(subject_todo.reload.deleted_at).to be_kind_of(ActiveSupport::TimeWithZone)
    end
  end

  context 'when todo item is to be recovered' do
    let(:subject_todo) { FactoryBot.create(:todo, item: "Item to be marked as completed!") }
    before do
      subject_todo.destroy!
    end
    it 'should soft-recover' do
      visit root_path
      within "tr#todo_#{subject_todo.id}" do
        click_on "Recover"
      end
      sleep 1
      #page.driver.browser.switch_to.alert.accept
      click_button 'Ok'
      sleep 1
      click_button 'OK'
      within "tr#todo_#{subject_todo.id}" do
        expect(page).to have_no_link('Recover')   # checking for front end section
        expect(page).to have_no_link('Purge')
        expect(page).to have_link('Destroy')
      end
      #Rails.logger.warn "*" * 80
      sleep 1 #Wait for backend to complete the soft-delete request
      expect(subject_todo.reload.deleted_at).to be nil
    end
  end

  context 'when todo item is to be purged' do
    let(:subject_todo) { FactoryBot.create(:todo, item: "Item to be marked as completed!") }
    before do
      subject_todo.destroy!
    end
    it 'should soft-purge' do
      visit root_path
      page_count = page.all(".markItem").size
      within "tr#todo_#{subject_todo.id}" do
        click_on "Purge"
      end
      sleep 1
      #page.driver.browser.switch_to.alert.accept
      click_button 'Ok'
      sleep 1
      click_button 'OK'
      sleep 2
      expect(page.all(".markItem").size).to eq(page_count-1)
      sleep 1 #Wait for backend to complete the soft-delete request
      expect { Todo.find(subject_todo.id) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end




