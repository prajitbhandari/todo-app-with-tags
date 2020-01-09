require 'rails_helper'
#require 'support/database_cleaner'
require 'support/factory_bot_rails'
RSpec.describe 'Todo App Crud Operation',js: true do
  context 'when todo item is to be created' do
    it 'should create todo-item' do
      visit root_path
      visit new_todo_path
      fill_in 'todo_item', with: Faker::Food.dish
      click_button 'Create Todo'
      visit todos_path
      sleep 1
      new_todo_item  = Todo.with_deleted.last
      debugger
      within "tr#todo_#{new_todo_item.id}" do
        expect(page).to have_content(new_todo_item.id)
        expect(page).to have_content(new_todo_item.item)
        expect(page).to have_content('Mark as completed')
        expect(page).to have_link('Show')
        expect(page).to have_link('Edit')
        expect(page).to have_link('Destroy')
      end
      expect { Todo.create(item: Faker::Food.dish ) }.to change { Todo.count }.by(1)
    end
  end

  context 'when todo item is to be marked as complete' do
    let(:subject_todo) { Todo.with_deleted.last }
    it 'should mark the todo item' do
      visit root_path
      #debugger
      within "tr#todo_#{subject_todo.id}" do
        find('.markItem').click
      end
      page.driver.browser.switch_to.alert.accept
      sleep 1
      within "tr#todo_#{subject_todo.id}" do
        #debugger
        expect(page.find("#item#{subject_todo.id}").style('color').to_s).to eq("{\"color\"=>\"rgba(0, 128, 0, 1)\"}")
      end
      sleep 1
      expect(subject_todo.reload.isCompleted).to be true
    end
  end

  context 'when specific todo item is to be displayed' do

  end

  context 'when todo item is to be edited' do

  end

  context 'when todo item is to be deleted' do
    #let!(:todo_items) { 5.times {|i| FactoryBot.create(:todo, item: "Todo item #{i}") } }
    let(:subject_todo) { Todo.with_deleted.last }
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

    it 'should soft-purge' do
      visit root_path
      page_count = page.all(".markItem").size
      before_todo_count = Todo.with_deleted.count
      within "tr#todo_#{subject_todo.id}" do
        click_on "Purge"
      end
      page.driver.browser.switch_to.alert.accept
      sleep 2
      expect(page.all(".markItem").size).to eq(page_count-1)
      Rails.logger.warn "*" * 80
      sleep 1 #Wait for backend to complete the soft-delete request
      after_todo_count = Todo.with_deleted.count
      #debugger
      expect { Todo.find(subject_todo.id) }.to raise_error ActiveRecord::RecordNotFound
      #expect{ after_todo_count }.to change{ before_todo_count }.by(-1)
    end
  end
end





#require 'rails_helper'
#require 'byebug'
#RSpec.describe 'Soft Delete Todo Item', js: true do
#  it 'with todo Destroy' do
#    visit 'http://localhost:3000'
#    #debugger
#    itemCount = page.all(".markItem").size
#    getId = 1 + rand(itemCount)
#    recover_or_purge_id = ["#recover", "#purge"].sample
#    if page.has_css?("#delete"+ getId.to_s, wait: 0)
#      find(:css, "#delete" + getId.to_s).click
#      alertPop = page.driver.browser.switch_to.alert
#      sleep 5
#      alertPop.accept  # can also be alertPop.dismiss
#      sleep 5
#    else
#      find(:css, recover_or_purge_id + getId.to_s).click
#      sleep 5
#      alertPop = page.driver.browser.switch_to.alert
#      sleep 5
#      alertPop.accept
#      sleep 5
#    end
#  end
#end




