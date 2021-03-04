class Publishers::SessionsController < Devise::SessionsController
  PUBLISHER_SESSION_KEYS = %i[
    publisher_id_token
    publisher_oid
    publisher_multiple_organisations
    organisation_urn
    organisation_uid
    organisation_la_code
  ].freeze

  def new; end

  def destroy
    PUBLISHER_SESSION_KEYS.each { |key| session.delete(key) }
    super
  end
end
