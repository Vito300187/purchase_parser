require './spec_helper'

current_page = Pages::TopPage.new('Москва')
IPAD = %w[Apple\ iPad\ Pro Apple\ iPad\ Air\ 2 Apple\ iPad\ Air Apple\ iPad\ mini\ 4 Apple\ iPad]

describe 'Find category' do
  context 'Apple' do
    current_page.enter_site_and_login_cabinet
    current_page.find_category('Apple', 'iPad')

    IPAD.each do |ipad_item|
      puts ipad_item
      current_page.check_item_checkbox(ipad_item)
      current_page.parsed_category_and_send_email
      current_page.click_pagination
      current_page.uncheck_item_checkbox(ipad_item)
    end
  end
end
