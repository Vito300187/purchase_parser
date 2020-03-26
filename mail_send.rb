require './spec_helper'

class SendMail
  def self.mail_about_low_price(price, item_name, link, result, selling_out)
    if price > 0 && result == true || selling_out == true
      Pony.mail(
        { to: ENV['EMAIL_TO'],
          subject: "Hurry up!!! LowPrice on #{item_name} !!!",
          body: "#{item_name}        #{price} RUB          https://www.mvideo.ru#{link}",
          charset: 'UTF-8',
          via: :smtp,
          attachments: { file = Dir['./screenshots/*.png'].first => File.read(file) },
          via_options: {
            user_name:             ENV['EMAIL_FROM'],
            password:              ENV['PASSWORD'],
            address:               'smtp.gmail.com',
            port:                  '587',
            authentication:        :plain,
            enable_starttls_auto:  true,
          }
        }
      )
      puts 'Mail send'
    end
  end
end
