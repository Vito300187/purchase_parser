require './spec_helper'

module Pages
  class TopPage
    include Capybara::DSL

    def initialize(city)
      @city                    = city
      @map_with_region         = '//div[@class="header-stores"]//a[contains(@class, "region-opener")]'
      @city_for_find           = "//li[contains(., '#{@city}')]"
      @current_city            = '//div[@class="header-stores"]/a'
      @check_box_apple         = '//a[text()="Watch"]'
      @contain_pagination_path = '.o-pagination-section'
      @button_next_pagination  = '//a[@class="c-pagination__next font-icon icon-up "]'
      @button_prev_pagination  = '//a[@class="c-pagination__prev font-icon icon-up "]'
      @first_pagination_page   =  '//a[@title="Перейти на страницу 1"]'
    end

    def close_iframe
      puts 'Закрытие ifrmae на главной странице сайта, для дальнейшей работы'
      unless find('.flocktory-widget').nil?
        iframe = find('iframe')
        within_frame(iframe) do
          find('div.close').click
        end
      end
    end

    def find_city
      puts 'Выбор города для поиска'

      if find(:xpath, @map_with_region).text != @city
        find(:xpath, @map_with_region).click
        find(:xpath, @city_for_find).click
        puts "Ваш город #{@city}, выбран!"
      else
        puts "Город соотвуетствует Вашему поиску #{@city}"
      end
    end

    def enter_site_and_login_cabinet
      Capybara.reset_sessions!
      visit '/'
      sleep 3
      # close_iframe
      find_city
      puts 'Вход в личный кабинет'

      click_link 'Войти'
      fill_in 'Email', with: 'Repz3@yandex.ru'
      fill_in 'password', with: 'Kuzminow300187'
      click_button 'Продолжить'

      # find(:xpath, '//a[text()="Войти"]').click
      # find(:xpath, '//input[@id="frm-email"]').set 'Repz3@yandex.ru'
      # find(:xpath, '//input[@id="frm-password"]').set 'Kuzminow300187'
      # find(:xpath, '//input[@id="submit-button"]').click

      WaitUtil.wait_for_condition(
      'Page include name Виталий',
      timeout_sec: 30,
      delay_sec: 0.5
      ) {page.has_content?('Виталий')}
    end

    def find_category(category, item)
      find(:xpath, "#{PATHS[category]}").hover
      puts "Open category #{category}, item #{item}"
      find(:xpath, "//strong[@class='header-nav-drop-down-title']//a[text()='#{item}']").click
    end

    def check_item_checkbox(item)
      find(:xpath, "//a[text()='#{item}']").click
    end

    def uncheck_item_checkbox(item)
      find(:xpath, "//a[text()='#{item}']").click
    end

    def page_contains_pagination?
      find(:css, @contain_pagination_path).visible?
    end

    def first_pagination_page
      find(:xpath, @first_pagination_page).click
    end

    def next_pagination
      if page.has_xpath?(@button_next_pagination)
        find(:xpath, @button_next_pagination)
      else
        puts 'Pages not found'
      end
    end

    def prev_pagination
      find(:xpath, @button_prev_pagination).click
    end

    def parsed_category_and_send_email
      open_current_url = open(current_url)
      parsed_page = Nokogiri::HTML(open_current_url)
      parsed_page.css('.c-product-tile.sel-product-tile-main').each do |watch_price|
        price = watch_price.css('.c-pdp-price__current').text.gsub(/[[:space:]]/, '').to_i
        item_name = watch_price.css('.sel-product-tile-title').text.strip
        link = watch_price.css('a.sel-product-tile-title').first[:href]

        SendMail.mail_about_low_price(price, item_name, link)
      end
    end
  end
end
