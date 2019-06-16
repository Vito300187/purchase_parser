require './spec_helper'

current_page = Pages::TopPage.new('Москва')

describe 'Find category' do
  context 'Apple MacBook' do
    current_page.enter_site_and_login_cabinet
    current_page.find_category('Apple', 'iMac')
    current_page.parsed_category_and_send_email
    current_page.click_pagination
    end

  context 'Apple iMac' do
    current_page.enter_site_and_login_cabinet
    current_page.find_category('Apple', 'Mac mini')
    current_page.parsed_category_and_send_email
    current_page.click_pagination
  end

  context 'System blocks Apple' do
    current_page.enter_site_and_login_cabinet
    current_page.find_category('Apple', 'MacBook')
    click_link 'MacBook'
    current_page.parsed_category_and_send_email
    current_page.click_pagination
  end
end
