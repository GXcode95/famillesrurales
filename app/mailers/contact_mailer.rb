# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  def contact_email(params)
    @params = params.with_indifferent_access
    @recipient_email = CONTACT_EMAIL

    mail(
      to: @recipient_email,
      reply_to: @params[:email],
      subject: "[Contact Familles Rurales] #{@params[:subject]}"
    )
  end
end
