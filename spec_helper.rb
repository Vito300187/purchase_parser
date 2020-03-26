require 'capybara'
require 'capybara-screenshot'
require 'nokogiri'
require 'pry'
require 'pony'
require 'rspec'
require 'selenium-webdriver'
require 'waitutil'
require 'yaml'
require './Pages/page.rb'
require './Pages/helpers.rb'
require './mail_send.rb'

YAML_PARAMS = YAML.load(File.read('./config/params.yaml'))

ENV['EMAIL_TO']   ||= YAML_PARAMS[:email_to]
ENV['EMAIL_FROM'] ||= YAML_PARAMS[:email_from]
ENV['PASSWORD']   ||= YAML_PARAMS[:password]

Capybara.app_host = 'https://www.mvideo.ru/'
Capybara.current_driver = :selenium_chrome
Capybara.page.driver.browser.manage.window.maximize
Capybara.default_max_wait_time = 10
Capybara.ignore_hidden_elements = true
Capybara::Screenshot.autosave_on_failure = false
Capybara.save_path = './screenshots'

# Capybara.current_driver = :selenium_chrome_headless
# Capybara.javascript_driver = :selenium

RSpec.configure { |config| config.include Capybara::DSL }

# Можно использовать все категории, по которым можно пройтись и выбрать для последующей проверки
INTERESTING_PRICE = 15000

CATEGORY                 = %w[Телевизоры Ноутбуки m_mobile: Авто Аксессуары Apple Телевизоры]
CATEGORY_DIF_PATH_FIRST  = %w[Фото Красота]
CATEGORY_DIF_PATH_SECOND = %w[Кухни Дома]
APPLE_DEVICE             = %w[Apple\ Watch iPhone iPad Mac Apple\ TV iPod Beats Аксессуары]

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
