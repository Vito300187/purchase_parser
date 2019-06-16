require './spec_helper'

module Helpers
  include Capybara::DSL

  def visit_home_page
    visit '/'
  end

  def logout_session
    page.reset!
  end

  def sell_out?
    page.has_text?('Рассрочка')
  end

  def clear_screenshots
    system('rm ./screenshots/*') unless Dir.glob('./screenshots/*').empty?
  end
end


