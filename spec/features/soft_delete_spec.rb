require 'rails_helper'
RSpec.describe 'Soft Delete Todo Item', js: true do
  it 'with todo Destroy' do
    visit 'http://localhost:3000'
    find('#delete11').click
    alertPop = page.driver.browser.switch_to.alert
    sleep 5
    alertPop.accept  # can also be a.dismiss
    sleep 5
  end
end









