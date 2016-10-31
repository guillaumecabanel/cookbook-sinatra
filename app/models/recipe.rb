class Recipe
  attr_reader :name, :description, :cooking_time, :difficulty, :tested

  def initialize(params)
    @name = params[:name]
    @description = params[:description]
    @cooking_time = params[:cooking_time]
    @difficulty = params[:difficulty]

    @tested = params[:tested] == "true" ? true : false
  end

  def mark_as_tested!
    @tested = true
  end
end
