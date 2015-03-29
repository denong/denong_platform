class ErrorsSerializer < ActiveModel::Serializer

  def as_json options=nil
    { error: object.full_messages.first }
  end
end