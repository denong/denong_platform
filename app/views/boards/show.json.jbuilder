json.extract! @board, :id, :title, :content
local_pic = image_url(@board.pic.photo.url(:product)) if @board.pic
json.pic @board.pic_url.present? ? @board.pic_url : local_pic

