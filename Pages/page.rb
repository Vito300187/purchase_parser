require './spec_helper'
require './Pages/helpers'

module Pages
  class TopPage
    include Capybara::DSL
    include Helpers

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
      @select_sort             = '//a[@class="select-button"]'
      @close_iframe            = '//div[contains(@class, "close")]'
      @showing_iframe_on_page  = 0
    end

    def close_iframe
      if @showing_iframe_on_page < 1
        iframe = find('iframe')
        within_frame(iframe) do
          find(:xpath, @close_iframe).click
        end
        puts 'Close iframe'
        @showing_iframe_on_page = 1
      end
      # unless find('.flocktory-widget').nil?
      #   iframe = find('iframe')
      #   within_frame(iframe) do
      #     find(:xpath, '//div[contains(@class, "close")]').click
      # find('div.close').click
      # find('div.pushtip-close').click
      # end
    end

    def find_city
      puts 'Select a city to search'
      if find(:xpath, @map_with_region).text != @city
        find(:xpath, @map_with_region).click
        find(:xpath, @city_for_find).click
        puts "Your city #{@city}, selected!"
      else
        puts "City matches Your search - #{@city}"
      end
    end

    def enter_site_and_login_cabinet
      Capybara.reset_sessions!
      visit_home_page
      sleep 3
      # close_iframe
      find_city
      puts 'Login to personal account'
      click_link 'Войти'
      fill_in 'Email', with: 'Repz3@yandex.ru'
      fill_in 'password', with: 'Kuzminow300187'
      click_button 'Продолжить'
      WaitUtil.wait_for_condition(
      'Page include name Виталий',
      timeout_sec: 30,
      delay_sec: 0.5
      ) {page.has_content?('Виталий')}
    end

    def find_category(category, item)
      sleep 3
      close_iframe
      find(:xpath, "#{PATHS[category]}").hover
      puts "Open category #{category} - #{item}"
      click_link item
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
      next_pagination.click if (page_contains_pagination? && !next_pagination.nil?)
      sleep 3
    end

    def first_pagination_page
      find(:xpath, @first_pagination_page).click if page.has_xpath?(@first_pagination_page)
      puts 'Go to the main page' if page.has_xpath?(@first_pagination_page)
    end

    def next_pagination
      find(:xpath, @button_next_pagination) if page.has_xpath?(@button_next_pagination)
    end

    def prev_pagination
      find(:xpath, @button_prev_pagination).click
    end

    def make_screenshot(price, link, interesting_price)
      if price > 0 && price <= interesting_price
        now_window = current_window
        interesting_item_window = open_new_window
        switch_to_window interesting_item_window
        visit "https://www.mvideo.ru#{link}"
        page.execute_script('window.scrollTo(0,000259)')
        save_screenshot
        switch_to_window now_window
        interesting_item_window.close
        true
      end
    end

    def parsed_category_and_send_email(interesting_price)
      loop do
        sleep 3
        open_current_url = open(current_url)
        parsed_page = Nokogiri::HTML(open_current_url)
        parsed_page.css('.c-product-tile.sel-product-tile-main').each do |item_price|
          price = item_price.css('.c-pdp-price__current').text.gsub(/[[:space:]]/, '').to_i
          item_name = item_price.css('.sel-product-tile-title').text.strip
          link = item_price.css('a.sel-product-tile-title').first[:href]
          result = make_screenshot(price, link, interesting_price)

          SendMail.mail_about_low_price(price, item_name, link, result)
          clear_screenshots
        end
        next_pagination.nil? ? break : next_pagination.click
        sleep 5
      end
    end

    def show_more_item?
      if page.has_xpath?(@show_more)
        find(:xpath, @show_more).click
        sleep 5
      end
    end

    def sort(sort_value)
      page.execute_script('window.scrollTo(0, 400)')
      find(:xpath, @select_sort).click
      click_link sort_value, match: :first
      sleep 5
    end
  end
end
