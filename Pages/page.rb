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
      @first_pagination_page   = '//a[@title="Перейти на страницу 1"]'
      @show_more               = '//span[contains(text(), "Показать еще")]'
    end

    def close_iframe
      unless find('.flocktory-widget').nil?
        iframe = find('iframe')
        puts 'Close iframe'
        within_frame(iframe) do
          find(:xpath, '//div[contains(@class, "close")]').click
          # find('div.close').click
          # find('div.pushtip-close').click
        end
      end
    end

    def find_city
      puts 'Select a city to search'

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
      puts 'Login to personal account'

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
      # close_iframe
      find(:xpath, "#{PATHS[category]}").hover
      puts "Open category #{category}, item #{item}"
      if !item.include?('iPhone')
        find(:xpath, "//strong[@class='header-nav-drop-down-title']//a[text()='#{item}']").click
      else
        click_link 'Apple iPhone'
      end
    end

    def check_item_checkbox(item)
      show_more_item?
      find(:xpath, "//a[text()='#{item}']").click
      sleep 5
    end

    def uncheck_item_checkbox(item)
      find(:xpath, "//a[text()='#{item}']").click
      sleep 5
    end

    def page_contains_pagination?
      find(:css, '.o-pagination-section').text.eql?('') ? false : true
    end

    def click_pagination
      if page_contains_pagination?
        until next_pagination.nil?
          next_pagination.click
          parsed_category_and_send_email
          sleep 1
        end

        first_pagination_page unless first_pagination_page.nil?
      end
    end

    def first_pagination_page
      find(:xpath, @first_pagination_page).click if page.has_xpath?(@first_pagination_page)
      puts 'Go to the main page' if page.has_xpath?(@first_pagination_page)
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

    def clear_screenshots
      system('rm ./screenshots/*') unless Dir.glob('./screenshots/*').empty?
    end

    def make_screenshot(price, link)
      if price > 0 && price <= INTERESTING_PRICE
        now_window = current_window
        interesting_item_window = open_new_window
        switch_to_window interesting_item_window
        visit "https://www.mvideo.ru#{link}"
        page.execute_script('window.scrollTo(0,000259)')
        screenshot_and_save_page
        switch_to_window now_window
        interesting_item_window.close
      end
    end

    def parsed_category_and_send_email
      open_current_url = open(current_url)
      parsed_page = Nokogiri::HTML(open_current_url)
      parsed_page.css('.c-product-tile.sel-product-tile-main').each do |watch_price|
        price = watch_price.css('.c-pdp-price__current').text.gsub(/[[:space:]]/, '').to_i
        item_name = watch_price.css('.sel-product-tile-title').text.strip
        link = watch_price.css('a.sel-product-tile-title').first[:href]
        make_screenshot(price, link)

        SendMail.mail_about_low_price(price, item_name, link)
      end

      clear_screenshots
    end

    def show_more_item?
      if page.has_xpath?(@show_more)
        find(:xpath, @show_more).click
        sleep 5
      end
    end
  end
end
