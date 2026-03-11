# frozen_string_literal: true

class ContactController < ApplicationController
  def new
    @contact = ContactForm.new
  end

  def create
    @contact = ContactForm.new(contact_params)

    if @contact.valid?
      ContactMailer.contact_email(contact_params.to_h).deliver_later
      redirect_to contact_path, notice: "Votre message a bien été envoyé. Nous vous répondrons dès que possible."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact_form).permit(:name, :email, :subject, :message)
  end
end
