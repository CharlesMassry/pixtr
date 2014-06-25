require "sinatra"

GALLERIES = {
  "cats" => ["grumpy_cat.png", "colonel_meow.jpg"],
  "dogs" => ["shibe.png"],
  "wombat" => []
}

get "/" do
  @galleries = GALLERIES.keys
  erb :gallery, layout: :layout
end

get "/:name" do
  @name = params[:name]
  @filenames = GALLERIES[@name]
  if GALLERIES.has_key?(@name)
    erb :index, layout: :layout
  else
    erb :error, layout: :layout
  end
end
