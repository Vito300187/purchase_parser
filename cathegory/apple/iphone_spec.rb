require './Pages/page.rb'
current_page = Pages::TopPage.new('Москва')

IPHONE = { 'Apple iPhone' => 17000 }

describe 'Перебор тестов' do
  IPHONE.each do |value, interesting_price|
    puts value
    current_page.enter_site_and_login_cabinet
    current_page.find_category('m_mobile:', value)
    current_page.sort('По цене')
    current_page.parsed_category_and_send_email(interesting_price)
  end
end
