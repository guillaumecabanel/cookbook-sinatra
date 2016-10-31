class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @recipe_view = RecipeView.new
  end

  def list
    @cookbook.all
  end

  def create
    recipe_data = @recipe_view.ask_user_for_recipe

    new_recipe = Recipe.new(recipe_data[:name],
                            recipe_data[:description],
                            recipe_data[:cooking_time],
                            recipe_data[:difficulty])

    @cookbook.add_recipe(new_recipe)
    @recipe_view.new_recipe_saved
  end

  def destroy
    recipes = @cookbook.all
    @recipe_view.display_all(recipes)
    id_to_destroy = @recipe_view.ask_user_for_id_delete[:id] - 1
    if @cookbook.all.include? @cookbook.all[id_to_destroy]
      @cookbook.remove_recipe(id_to_destroy)
    else
      @recipe_view.wrong_id
    end
  end

  def import_from_marmiton
    # View ask for a {:keyword}

    parameters = @recipe_view.ask_for_keyword
    # Fetch list search({:keyword})
    @recipe_view.please_wait(parameters[:keyword])
    list = MarmitonFetcher.fetch_list(parameters[:keyword])

    return @recipe_view.no_result(parameters[:keyword]) if list.empty?
    # View list and view ask for a recipe
    index = @recipe_view.ask_for_title(list) - 1
    # create recipe
    new_recipe = recipe_from_details(list[index])

    @cookbook.add_recipe(new_recipe)
    @recipe_view.new_recipe_saved
  end

  def mark_as_tested
    recipes = @cookbook.all
    @recipe_view.display_all(recipes)
    id_to_mark_as_done = @recipe_view.ask_user_for_id_test[:id] - 1
    if @cookbook.all.include? @cookbook.all[id_to_mark_as_done]
      @cookbook.mark_as_done(id_to_mark_as_done)
    else
      @recipe_view.wrong_id
    end
  end

  private

  def recipe_from_details(details)
    Recipe.new(details[:title],
               details[:description],
               details[:cooking_time],
               details[:difficulty])
  end
end
