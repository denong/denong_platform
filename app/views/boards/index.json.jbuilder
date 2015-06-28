json.array!(@boards) do |board|
  json.extract! board, :id, :title
  json.pic board.picture_url
end
