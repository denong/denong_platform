json.extract! @board, :id, :title, :content
json.pic image_url(@board.pic.photo.url(:product)) if @board.pic

