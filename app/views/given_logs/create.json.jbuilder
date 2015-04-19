json.extract! @giver_log, :customer_id, :giver_or_given_id
json.amount @giver_log[:amount].abs