# Deployable MVP

* Asks for contact info
* Can order new supplies
* Can check request history

# Backlog

* Better error handling - make _sure_ the user always gets a response. Should we have a Handler::Errors? Bot instance with error handler?
* Users are notified via Telegram when responses are sent
* Users can control their notification preferences - SMS, Telegram, email
* Web view of bot message traffic
  * Admin only
  * Can open page and see a message log
  * To help admins to help users when the bot doesn't recognize intent
* Better fuzzy matching (of supplies and general requests)
* Admin-only bot utilities
  * Report running