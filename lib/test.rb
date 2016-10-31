require "csv"

require_relative 'recipe'
require_relative 'cookbook'    # You need to create this file!
require_relative 'controller'  # You need to create this file!
require_relative 'router'


# Tests

# pasta = Recipe.new("Pasta", "Pasta with tomatoes and carots")
# soup = Recipe.new("Pasta", "Very good soup!")

csv_file   = File.join(__dir__, 'recipes.csv')
cookbook   = Cookbook.new(csv_file)
controller = Controller.new(cookbook)

controller.import_from_marmiton
