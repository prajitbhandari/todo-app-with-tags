require 'rails_helper'
#require 'support/database_cleaner'
require 'support/factory_bot_rails'
RSpec.describe 'Todo App Crud Operation',js: true do
  let(:subject_todo) { Todo.with_deleted.last }
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
      debugger
      within "tr#todo_#{new_todo_item.id}" do
        expect(page).to have_content(new_todo_item.id)
        expect(page).to have_content(new_todo_item.item)
        expect(page).to have_content('Mark as completed')
        expect(page).to have_link('Show')
        expect(page).to have_link('Edit')
        expect(page).to have_link('Destroy')
      end
      expect { Todo.create(item: new_todo_item_name ) }.to change { Todo.count }.by(1)
    end
  end

  context 'when todo item is to be marked as complete' do
    it 'should mark the todo item' do
      visit root_path
      #debugger
      within "tr#todo_#{subject_todo.id}" do
        find('.markItem').click
      end
      sleep 2
      page.driver.browser.switch_to.alert.accept
      sleep 2
      within "tr#todo_#{subject_todo.id}" do
        #debugger
        if subject_todo.isCompleted
          expect(page.find("#item#{subject_todo.id}").style('color').to_s).to eq("{\"color\"=>\"rgba(0, 0, 0, 1)\"}")
          expect(subject_todo.reload.isCompleted).to be false
        else
          expect(page.find("#item#{subject_todo.id}").style('color').to_s).to eq("{\"color\"=>\"rgba(0, 128, 0, 1)\"}")
          expect(subject_todo.reload.isCompleted).to be true
        end
      end
      sleep 1
    end
  end

  context 'when specific todo item is to be displayed' do
    it 'should show indiviual item detail' do
      visit root_path
      within "tr#todo_#{subject_todo.id}" do
        click_on "Show"
      end
      sleep 2
      visit  subject_todo
    end
  end

  context 'when todo item is to be edited' do
    it 'should modify the indiviual item ' do
      visit root_path
      within "tr#todo_#{subject_todo.id}" do
        click_on "Edit"
      end
      sleep 1
      visit  edit_todo_path(subject_todo.id)
      updated_item = Faker::Food.dish
      fill_in('todo_item', :with => updated_item)
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
    #let!(:todo_items) { 5.times {|i| FactoryBot.create(:todo, item: "Todo item #{i}") } }
    it 'should soft-delete' do
      visit root_path
      within "tr#todo_#{subject_todo.id}" do
        click_on "Destroy"
      end
      page.driver.browser.switch_to.alert.accept
      within "tr#todo_#{subject_todo.id}" do
        expect(page).to have_no_link('Destroy')   # checking for front end section
        expect(page).to have_link('Recover')
        expect(page).to have_link('Purge')
        #TODO:
        # - check destroy link is not available
        # - check recover link has appeared
        # - check purge link has appeared
      end
      Rails.logger.warn "*" * 80
      sleep 1 #Wait for backend to complete the soft-delete request
      expect(subject_todo.reload.deleted_at).not_to be nil
      expect(subject_todo.reload.deleted_at).to be_kind_of(ActiveSupport::TimeWithZone)
    end
  end

  context 'when todo item is to be recovered' do
    it 'should soft-recover' do
      visit root_path
      within "tr#todo_#{subject_todo.id}" do
        click_on "Recover"
      end
      page.driver.browser.switch_to.alert.accept
      within "tr#todo_#{subject_todo.id}" do
        expect(page).to have_no_link('Recover')   # checking for front end section
        expect(page).to have_no_link('Purge')
        expect(page).to have_link('Destroy')
      end
      Rails.logger.warn "*" * 80
      sleep 1 #Wait for backend to complete the soft-delete request
      expect(subject_todo.reload.deleted_at).to be nil
    end
  end

  context 'when todo item is to be purged' do
    it 'should soft-purge' do
      visit root_path
      page_count = page.all(".markItem").size
      todo_count_before = Todo.with_deleted.count
      within "tr#todo_#{subject_todo.id}" do
        click_on "Purge"
      end
      page.driver.browser.switch_to.alert.accept
      sleep 2
      todo_count_after = Todo.with_deleted.count
      expect(page.all(".markItem").size).to eq(page_count-1)
      Rails.logger.warn "*" * 80
      sleep 1 #Wait for backend to complete the soft-delete request
      #debugger
      #expect { Todo.find(subject_todo.id) }.to raise_error ActiveRecord::RecordNotFound
      expect(todo_count_before-1).to eq(todo_count_after)
      #expect { todo_before.really_destroy! }.to change { todo_count_before }.by(1)
    end
  end
end




