json.array!(@boards) do |board|
  json.extract! board, :id, :title
  json.pic image_url(board.pic.photo.url(:product)) if board.pic
end
