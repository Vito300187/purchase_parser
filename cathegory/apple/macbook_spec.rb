require './Pages/page.rb'

current_page = Pages::TopPage.new('Москва')

MACBOOK = {
  'iMac'     => 16000,
  'Mac mini' => 30000,
  'MacBook'  => 30000
}

describe 'Find category' do
  binding.pry
  MACBOOK.each do |value, interesting_price|
    puts value
    binding.pry
    current_page.enter_site_and_login_cabinet
    current_page.find_category('Apple', value)
    current_page.sort('По цене')
    click_link 'MacBook' if value.include?('MacBook')
    current_page.parsed_category_and_send_email(interesting_price)
  end
end
