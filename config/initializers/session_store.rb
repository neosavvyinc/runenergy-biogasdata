# Be sure to restart your server when you modify this file.

# Biogasdata::Application.config.session_store :cookie_store, key: '_biogasdata_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
Biogasdata::Application.config.session_store :active_record_store, {
    :secure => false
}
