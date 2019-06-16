require './spec_helper'
current_page = Pages::TopPage.new('Москва')

CONSOLE = {
  'Консоли Xbox One'    => 16000,
  'Консоли PlayStation' => 16000,
  'Игры для Xbox One'   => 490,
  'Игры PS4'            => 490
}

describe 'Перебор тестов' do
  CONSOLE.each do |value, interesting_price|
    puts value
    current_page.enter_site_and_login_cabinet
    current_page.find_category('Игры', value)
    current_page.sort('По цене')
    current_page.parsed_category_and_send_email(interesting_price)
    current_page.click_pagination
  end
end
