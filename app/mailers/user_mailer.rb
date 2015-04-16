class UserMailer < ApplicationMailer
  default form: "uwismnotifokations@gmail.com",
          sent_on:    Time.now

  def notification_email(user)
    @user = user
    p @user
    mail to: "root@mail.ru",
         subject: "User registrate",
         template_path: 'mailers'

  end

end
