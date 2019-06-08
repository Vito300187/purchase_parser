require './spec_helper'

current_page = Pages::TopPage.new('Москва')
WATCH = %w[Watch\ Series\ 1 Watch\ Series\ 3 Watch\ Series\ 4]

describe 'Find category Apple' do
  current_page.enter_site_and_login_cabinet
  current_page.find_category('Apple', 'Apple Watch')
  current_page.check_item_checkbox('Watch')

  WATCH.each do |series|
    puts series
    current_page.check_item_checkbox(series)
    current_page.parsed_category_and_send_email
    current_page.click_pagination
    current_page.uncheck_item_checkbox(series)
  end
end
