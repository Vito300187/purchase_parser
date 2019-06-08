require './spec_helper'

current_page = Pages::TopPage.new('Москва')
IPHONE = %w[iPhone\ Xs\ Max iPhone\ Xs iPhone\ Xr iPhone\ X iPhone\ 8 iPhone\ 8\ Plus
            iPhone\ 7 iPhone\ 7\ Plus iPhone\ SE iPhone\ 6S iPhone\ 6S\ Plus iPhone\ 6 iPhone\ 5S]

describe 'Find category' do
  context 'Apple' do
    current_page.enter_site_and_login_cabinet
    current_page.find_category('m_mobile:', 'Apple iPhone')

    IPHONE.each do |iphone_item|
      puts iphone_item
      current_page.check_item_checkbox(iphone_item)
      current_page.parsed_category_and_send_email
      current_page.click_pagination
      current_page.uncheck_item_checkbox(iphone_item)
    end
  end
end
