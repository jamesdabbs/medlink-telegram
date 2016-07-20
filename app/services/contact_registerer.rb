class ContactRegisterer
  def call medlink:, user:, contact:
    credentials = medlink.credentials_for_phone_number \
      phone_number: contact.phone_number
    user.attach contact: contact, credentials: credentials
  end
end
