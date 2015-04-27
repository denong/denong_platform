if @identity_verify.present?
  json.extract! @identity_verify, :verify_state
else
  json.verify_state "unverified"
end