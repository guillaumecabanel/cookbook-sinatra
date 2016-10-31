class Cookbook # <=> RecipeRepository
  def initialize(csv_file)
    @csv_file = csv_file
    @cookbook = []
    load_recipes
  end

  def add_recipe(recipe)
    @cookbook << recipe
    save_recipes
  end

  def remove_recipe(recipe_id)
    @cookbook.delete_at(recipe_id)
    save_recipes
  end

  def all
    @cookbook
  end

  def mark_as_done(recipe_id)
    @cookbook[recipe_id].mark_as_tested!
    save_recipes
  end

  private

  def load_recipes
    CSV.foreach(@csv_file) do |row|
      recipe = Recipe.new({name: row[0], description: row[1], cooking_time:row[2], difficulty: row[3], tested: row[4]})
      @cookbook << recipe
    end
  end

  def save_recipes
    csv_options = { col_sep: ',', quote_char: '"', force_quotes: true }

    CSV.open(@csv_file, 'wb', csv_options) do |csv|
      @cookbook.each do |recipe|
        csv << [recipe.name,
                recipe.description,
                recipe.cooking_time,
                recipe.difficulty,
                recipe.tested]
      end
    end
  end
end

