# frozen_string_literal: true

# Email de destination des messages du formulaire de contact
# Surchargeable via CONTACT_EMAIL (ex: sur Render dans Environment)
CONTACT_EMAIL = ENV.fetch("CONTACT_EMAIL", "xavier.grenouillet@gmail.com").freeze
