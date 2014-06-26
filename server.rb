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
  erb :gallery, layout: :layout
end

get "/galleries/new" do
  erb :new_gallery, layout: :layout
end

get "/:gallery_name" do
  @name = params[:gallery_name]
  @name.capitalize!
  @gallery = Gallery.find_by(name: @name)
  if !@gallery.nil?
    @images = @gallery.images
    erb :index, layout: :layout
  else
    erb :error, layout: :layout
  end
end

post '/galleries' do
  gallery = Gallery.new(params[:gallery])
  gallery.save
  redirect to("/#{gallery.name}")
end
