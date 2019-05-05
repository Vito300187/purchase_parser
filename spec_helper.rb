require 'chromedriver2/helper'
require 'capybara'
require 'capybara-select2'
require 'capybara/dsl'
require 'capybara/rspec'
require 'nokogiri'
require 'pry'
require 'pry-rescue'
require 'pony'
require 'rspec'
require 'selenium-webdriver'
require 'waitutil'
require 'yaml'
require './Pages/page'
require './mail_send.rb'

Capybara.app_host = 'https://www.mvideo.ru/'
Capybara.current_driver = :selenium_chrome
Capybara.page.driver.browser.manage.window.maximize
Capybara.default_max_wait_time = 10
# Capybara.current_driver = :selenium_chrome_headless
# Capybara.javascript_driver = :selenium

RSpec.configure do |config|
  config.include Capybara::DSL
end

# Можно использовать все категории, по которым можно пройтись и выбрать для последующей проверки
CATEGORY                 = %w[Телевизоры Ноутбуки m_mobile: Авто Аксессуары Apple Телевизоры]
CATEGORY_DIF_PATH_FIRST  = %w[Фото Красота]
CATEGORY_DIF_PATH_SECOND = %w[Кухни Дома]
APPLE_DEVICE             = %w[Apple\ Watch iPhone iPad Mac Apple\ TV iPod Beats Аксессуары]

INTERESTING_PRICE = 10000

# Пути нужны для постановки пути в универсальный метод
PATHS = {
  'Apple'       => '//span[contains(text(), "Apple")]',
  'm_mobile:'   => '//span[contains(text(),"m_mobile")]',
  'Авто'        => '//span[contains(text(), "Авто")]',
  'Аксессуары'  => '//span[contains(text(), "Аксессуары")]',
  'Дома'        => '//nobr[normalize-space() = "Техника для дома"]',
  'Игры'        => '//nobr[normalize-space() = "Игры и софт, развлечения"]',
  'Красота'     => '//nobr[contains(text(), "Красота")]',
  'Кухни'       => '//nobr[normalize-space() = "Техника для кухни"]',
  'Ноутбуки'    => '//span[contains(text(), "Ноутбуки")]',
  'Телевизоры'  => '//span[contains(text(), "Телевизоры")]',
  'Фото'        => '//nobr[contains(text(), "Фото")]',
}

YAML_PARAMS = YAML.load(File.read('./config/email.params.yaml'))
