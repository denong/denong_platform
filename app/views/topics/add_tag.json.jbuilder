json.extract! @topic, :title, :subtitle
json.pic image_url(@topic.pic.photo.url(:product)) if @topic.pic
json.tags @topic.tag_list