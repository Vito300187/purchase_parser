require './Pages/page.rb'
current_page = Pages::TopPage.new('Москва')

WATCH = {
  'Watch Series 1' => 15000,
  'Watch Series 3' => 15000,
  'Watch Series 4' => 15000
}

describe 'Find category Apple' do
  current_page.enter_site_and_login_cabinet
  current_page.find_category('Apple', 'Apple Watch' )
  current_page.check_item_checkbox('Watch')
  current_page.sort('По цене')

  WATCH.each do |value, interesting_price|
    puts value
    current_page.parsed_category_and_send_email(interesting_price)
  end
end
