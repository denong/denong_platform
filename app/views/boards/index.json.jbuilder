json.array!(@boards) do |board|
  json.extract! board, :id, :title
  json.pic picture_url
end
