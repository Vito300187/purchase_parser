require './spec_helper'

# (По умолчанию стоит город Москва, но можно выбрать любой из списка на сайте MVIDEO)
current_page = Pages::TopPage.new('Москва')

describe 'Find category Apple' do
  current_page.enter_site_and_login_cabinet
  # 4) Перейти в интересующую категорию, используя ключи из константы spec_helper
  # "Телевизоры", "Ноутбуки", "m_mobile:", "Фото", "Кухни", "Дома", "Красота",
  # "Авто", "Игры и софт, развлечения", "Аксессуары", "apple"
  current_page.find_category('Apple', 'Apple Watch')
  # 5) Остаться на текущей странице, чтобы можно было к ней возвращаться, при переходе по ссылке

  context 'Apple Watch 4' do
    current_page.check_item_checkbox('Watch')
    current_page.check_item_checkbox('Watch Series 4')

    if current_page.page_contains_pagination?
      until current_page.next_pagination.nil?
        current_page.next_pagination.click
        current_page.parsed_category_and_send_email
      end

      puts 'Переход на первую страницу'
      current_page.first_pagination_page
    end

    current_page.uncheck_item_checkbox('Watch Series 4')
  end

  context 'Apple Watch 3' do
  end
end


# Тест кейс

# Приоритеты apple, Игры, Пылесосы, Фото и видео, Компьютерная техника apple
# 4) Сделать перебор по категориям, подставляя товар для проверки - done
# 5) Найти товары менее определенной цены - done
# 6) Добавить товары определенной цены и сообщить на почту, что есть заказ
# 7) Запустить тест через каждые 5 минут с повтором
# 8) Запустить тест на CI, чтобы отслеживать ошибки по тесту
