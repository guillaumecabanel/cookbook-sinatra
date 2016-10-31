require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require "csv"

require_relative 'models/recipe'
require_relative 'models/cookbook'
require_relative 'views/recipe_view'
require_relative 'controllers/controller'
require_relative 'services/marmiton_fetcher'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)

end

get '/' do
  csv_file = File.join(__dir__, 'recipes.csv')
  COOKBOOK = Cookbook.new(csv_file)
  @recipes = COOKBOOK.all
  erb :index
end

get '/recipes/new' do
  erb :new
end

post '/recipes/create' do
  csv_file = File.join(__dir__, 'recipes.csv')
  new_recipe = Recipe.new(params)
  COOKBOOK = Cookbook.new(csv_file)
  COOKBOOK.add_recipe(new_recipe)
  redirect '/'
end

get '/recipes/:id/delete' do
  csv_file = File.join(__dir__, 'recipes.csv')
  COOKBOOK = Cookbook.new(csv_file)
  COOKBOOK.remove_recipe(params[:id].to_i)
  redirect '/'
end

get '/marmiton/import' do
  erb :import_from_marmiton
end

get '/marmiton/search' do
  @results = MarmitonFetcher.fetch_list(params[:keyword])
  @keyword = params[:keyword]
  erb :marmiton_index
end

get 'marmiton/:id/save' do
  # new_recipe = recipe_from_details(list[index])
  # @cookbook.add_recipe(new_recipe)
  csv_file = File.join(__dir__, 'recipes.csv')
  COOKBOOK = Cookbook.new(csv_file)
  new_recipe = Recipe.new(@results[params[:id].to_i][:title],
                          @results[params[:id].to_i][:description],
                          @results[params[:id].to_i][:cooking_time],
                          @results[params[:id].to_i][:difficulty])

  COOKBOOK.add_recipe(new_recipe)
  redirect '/'
end
