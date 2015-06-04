if @identity_verify.present?
  json.extract! @identity_verify, :id_card, :name, :verify_state
else
  json.verify_state "unverified"
end