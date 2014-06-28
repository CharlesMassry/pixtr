require "sinatra"
require "active_record"

ActiveRecord::Base.establish_connection(
    adapter: 'postgresql',
    database: 'pixtr'
)

class Image < ActiveRecord::Base
end

class Gallery < ActiveRecord::Base
  has_many :images
end

get "/" do
  @galleries = Gallery.order("name ASC")
  erb :gallery
end

get "/galleries/new" do
  erb :new_gallery
end

get "/galleries/:id" do
  @gallery = Gallery.find(params[:id])
  if !@gallery.nil?
    @images = @gallery.images
    erb :index
  else
    erb :error
  end
end

post "/galleries" do
  gallery = Gallery.new(params[:gallery])
  gallery.name.capitalize!
  gallery.save
  redirect to("/galleries/#{gallery.id}")
end

get "/galleries/:id/images/new" do
  @gallery = Gallery.find(params[:id])
  erb :new_image
end

post "/galleries/:id/images/new" do
  image = Image.create(params[:image])
  redirect to("galleries/#{image.gallery_id}")
end

get "/galleries/:id/edit" do
  @gallery = Gallery.find(params[:id])
  erb :edit_gallery
end

put "/galleries/:id" do
  gallery = Gallery.find(params[:id])
  gallery.update(params[:gallery])
  redirect to("/galleries/#{params[:id]}")
end

delete "/galleries/:id/delete" do
  gallery = Gallery.find(params[:id])
  gallery.destroy
  redirect to("/")
end

delete "/galleries/:id/images/:image_id/delete" do
  image = Image.find(params[:image_id])
  image.destroy
  redirect to("/galleries/#{params[:id]}")
end

