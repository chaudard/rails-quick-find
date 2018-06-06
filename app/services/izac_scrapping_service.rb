# require 'rest-client'
require "open-uri"
require 'nokogiri'

class IzacScrappingService
  BASE_URL = "https://www.izac.fr/fr/catalogsearch/result/?q=".freeze
  # SITE_URL = "https://www.zara.com"
  USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36"

  def initialize(keywords) # array of words
    @keywords = keywords
  end

  def call
    full_links = scrap_1
    articles = scrap_2(full_links)
    p articles
  end

  private

  def scrap_1
    full_links = []
    suffix = ''
    @keywords.each_with_index do |word, index|
      suffix += word
      suffix += '+' if index < @keywords.size-1
    end
    url = BASE_URL + suffix
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    # response = RestClient.get(BASE_URL + @keywords, {user_agent: USER_AGENT})
    # html_doc = Nokogiri::HTML(response.body)

    html_doc.search('.product-image').each do |element|
      full_link = element.attribute('href').value
      full_links << full_link
    end
    return full_links
  end

  def scrap_2(liste)
    articles = []
    liste.each do |url|
      html_file = open(url).read
      html_doc = Nokogiri::HTML(html_file)
      images = []
      article = {}
      size_stock = {}

      article[:url] = url
      html_doc.search('.thumb-link img').each do |element|
        image = element.attribute('src').value
        images << image
      end

      html_doc.search('.product-name').each do |element|
        article[:title] = cleaning(element.children.text)
      end

      html_doc.search('.box-description .std').each do |element|
        article[:description] = cleaning(element.text)
      end
      # recherche du prix hors promo si existant
      html_doc.search('.regular-price').each do |element|
        article[:price] =  clean_price(element.text.strip)
      end
      # recherche du prix en promo si existant
      html_doc.search('.special-price').each do |element|
        article[:price] =  clean_price(element.text.strip)
      end

      html_doc.search('.swatch-link-158').each do |element|
        size = cleaning(element.text).strip
        size = size[0,3].strip
        size_stock[size] = true
        if element.parent.attributes["class"].value.include? "indispo"
          size_stock[size] = false
        end
      end
      article[:size_stock] = size_stock
      article[:images] = images
      articles << article
    end
    return articles
  end

  private

  #enlever les carac spéciaux des textes
  def cleaning(element)
    element.gsub!(/\r/, '')
    element.gsub!(/\t/, '')
    element.gsub!(/\n/, '')
    return element.strip
  end

  #enlever les carac du prix
  def clean_price(price)
    regexp = /\D/
    price.gsub(regexp, '')
  end

end


