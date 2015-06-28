json.array!(@boards) do |board|
  json.extract! board, :id, :title
  local_pic = image_url(board.pic.photo.url(:product)) if board.pic
  json.pic board.pic_url.present? ? board.pic_url : local_pic
end
