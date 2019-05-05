require './spec_helper'

current_page = Pages::TopPage.new('Москва')

describe 'Find category' do
  context 'Apple' do
    current_page.enter_site_and_login_cabinet
  end
end
