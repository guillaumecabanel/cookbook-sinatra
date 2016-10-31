class RecipeView
  def display_all(cookbook)
    if cookbook.empty?
      puts "No recipe yet... Add one!"
    else
      puts "Your recipes:"
      cookbook.each_with_index do |recipe, index|
        tested = recipe.tested ? "[X]" : "[ ]"
        puts "#{tested} #{index + 1}. #{recipe.name} (#{recipe.cooking_time}, #{recipe.difficulty}):"
        puts "#{recipe.description}\n---------------------------------------"
      end
    end
  end

  def ask_user_for_recipe
    parameters = {}

    parameters[:name] = ask_and_get("What's the name of your recipe?")
    parameters[:description] = ask_and_get("What's the steps to make it ?")
    parameters[:cooking_time] = ask_and_get("How long does it take?")
    parameters[:difficulty] = ask_and_get("How difficult it is?")

    return parameters
  end


  def ask_user_for_id_delete
    parameters = {}
    puts "Wich recipe do you want to delete?"
    print ">"
    parameters[:id] = gets.chomp.to_i

    return parameters
  end

  def ask_user_for_id_test
    parameters = {}
    puts "Wich recipe do you want to mark as tested?"
    print ">"
    parameters[:id] = gets.chomp.to_i

    return parameters
  end

  def wrong_id
    puts "This recipe doesn't exist."
  end

  def please_wait(keyword)
    puts "Searching for \"#{keyword}\" recipes..."
  end

  def no_result(keyword)
    puts "Sorry, no result for \"#{keyword}\"..."
  end

  def ask_for_keyword
    parameters = {}
    puts "What are you looking for?"
    print ">"
    parameters[:keyword] = gets.chomp
    return parameters
  end

  def ask_for_title(results)
    results.each_with_index do |recipe, index|
      puts "#{index + 1}. #{recipe[:title]}"
    end

    puts "Wich recipe do you want to add?"
    print ">"
    gets.chomp.to_i
  end

  def new_recipe_saved
    puts "Your recipe has been saved :)"
  end

  private

  def ask_and_get(question)
    puts question
    print ">"
    gets.chomp
  end
end
