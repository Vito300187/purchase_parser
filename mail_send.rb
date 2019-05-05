require './spec_helper'
require './config/email.params.yml'
require 'yaml'

# Как выбрать из yaml файла ?

class SendMail
  def self.mail_about_low_price(price, item_name, link)
    unless price.nil?
      if price > 0 && price <= INTERESTING_PRICE
        Pony.mail(
          { to: :email,
            via: :smtp,
            subject: "Hurry up!!! LowPrice on #{item_name} !!!",
            body: "#{item_name} - #{price} рублей - https://www.mvideo.ru#{link}",
            via_options: :via_options }
        )
      end
    end
  end
end
