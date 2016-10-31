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
