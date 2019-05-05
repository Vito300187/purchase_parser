require './spec_helper'

class SendMail
  def self.mail_about_low_price(price, item_name, link)
    unless price.nil?
      if price > 0 && price <= INTERESTING_PRICE
        Pony.mail(
          { to: YAML_PARAMS[:email_to],
            subject: "Hurry up!!! LowPrice on #{item_name} !!!",
            body: "#{item_name}        #{price} RUB          https://www.mvideo.ru#{link}",
            via: :smtp,
            via_options: {
              user_name:             YAML_PARAMS[:email_from],
              password:              YAML_PARAMS[:password],
              address:               'smtp.gmail.com',
              port:                  '587',
              authentication:        :plain,
              enable_starttls_auto:  true,
            }
          }
        )
      end
    end
  end
end
