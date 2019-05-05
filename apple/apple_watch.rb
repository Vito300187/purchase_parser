require './spec_helper'

# (По умолчанию стоит город Москва, но можно выбрать любой из списка на сайте MVIDEO)
current_page = Pages::TopPage.new('Москва')
WATCH = %w[Watch\ Series\ 1 Watch\ Series\ 3 Watch\ Series\ 4]

describe 'Find category Apple' do
  current_page.enter_site_and_login_cabinet
  current_page.find_category('Apple', 'Apple Watch')
  current_page.check_item_checkbox('Watch')

  WATCH.each do |series|
    current_page.check_item_checkbox(series)
    current_page.parsed_category_and_send_email
    current_page.click_pagination
    current_page.uncheck_item_checkbox(series)
  end
end


# Приоритеты Apple, Игры, Пылесосы, Фото и видео, Компьютерная техника apple
# 7) Запустить тест через каждые 5 минут с повтором
# 8) Запустить тест на CI, чтобы отслеживать ошибки по тесту
