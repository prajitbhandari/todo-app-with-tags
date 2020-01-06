require 'rails_helper'
require 'byebug'
RSpec.describe 'Soft Delete Todo Item', js: true do
  it 'with todo Destroy' do
    visit 'http://localhost:3000'
    #debugger
    itemCount = page.all(".markItem").size
    getId = 1 + rand(itemCount)
    if page.has_css?("#delete"+ getId.to_s, wait: 0)
      find(:css, "#delete" + getId.to_s).click
      alertPop = page.driver.browser.switch_to.alert
      sleep 5
      alertPop.accept  # can also be alertPop.dismiss
      sleep 5
    else
      find(:css, "#recover" + getId.to_s).click
      sleep 5
      alertPop = page.driver.browser.switch_to.alert
      sleep 5
      alertPop.accept
      sleep 5
    end
  end
end









