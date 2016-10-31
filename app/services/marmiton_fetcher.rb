require 'open-uri'
require 'nokogiri'

class MarmitonFetcher
  def self.fetch_list(keyword)
    core_url = "http://www.marmiton.org/recettes/recherche.aspx?aqt="
    url = "#{core_url}#{keyword}"
    # url = "fraise.html" # Test only

    html_doc = get_html(url)
    return nil if html_doc.nil?

    target = '.m_contenu_resultat'

    # Return [{:title, :description}, {:title, :description}, ...]
    fetch_recipes(html_doc, target)
  end

  def self.get_html(url)
    html_file = open(url)
    Nokogiri::HTML(html_file)

  rescue SocketError => error
    puts "#{error.message}.\nVerify your connection... and retry!"
    nil
  end

  def self.fetch_recipes(html_doc, target)
    recipes = []

    html_doc.search(target).each do |element|
      title = encode_utf8(find_title(element))
      next if title.nil?
      recipes << details_to_hash(title, get_details(element))
    end

    recipes
  end

  def self.get_details(element)
    description = encode_utf8(find_description(element))
    cooking_time = encode_utf8(find_cooking_time(element))
    difficulty = encode_utf8(find_difficulty(element))

    [description, cooking_time, difficulty]
  end

  def self.details_to_hash(title, details)
    {
      name: title,
      description: details[0],
      cooking_time: details[1].strip,
      difficulty: details[2]
    }
  end

  def self.find_title(element)
    # <div class="m_titre_resultat">
    #   <a [...] title="Charlotte aux fraises" href="[...]>
    #     Charlotte aux <b>fraises</b>
    #   </a>
    # </div>

    element.children.search('.m_titre_resultat').first.first_element_child['title']
  end

  def self.find_description(element)
    # <div class="m_texte_resultat">
    #   Ingredients : moules, boudoir, gervita, Alcools, <b>fraise</b>, sucre.
    #   Equeutez les <b>fraises</b>, coupez- les en grands morceauxhttps://github.com/sparklemotion/nokogiri/wiki/Cheat-sheet.
    #   Placez le film plastique en en laissant deborder largement.
    #   Faire fondre le sucre dans de l'eau ou diluez l'alcool,...
    # </div>

    element.children.search('.m_texte_resultat').first.text
  end

  def self.find_cooking_time(element)
    # <div class="m_detail_time">
    #   <div style="float:left;">
    #     <div class="m_prep_time"></div>
    #     15 min
    #   </div>
    # </div>

    element.children.search('.m_detail_time').first.first_element_child.text
  end

  def self.find_difficulty(element)
    # <div class="m_detail_recette">
    # <strong>Recette</strong> - Dessert - Tres facile - Bon marche - Vegetarien
    # </div>
    details = element.children.search('.m_detail_recette').first.text.split(" - ")
    details[2]
  end

  def self.encode_utf8(text)
    text.encode("iso-8859-1").force_encoding("utf-8") unless text.nil?
  end
end


