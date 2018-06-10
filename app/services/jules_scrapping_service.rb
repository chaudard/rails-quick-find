require 'open-uri'
require 'nokogiri'

class JulesScrappingService
  BASE_URL = "http://www.jules.com/fr/recherche?q=";

  def initialize(keywords) # array of words
    @keywords = keywords
  end

  def call
    full_links = scrap_1
    # p full_links
    articles = scrap_2(full_links)
    p articles
  end

  private

  def scrap_1
    full_links = []
    suffix = ''
    @keywords.each_with_index do |word, index|
      suffix += word
      suffix += '%20' if index < @keywords.size-1
    end
    url = BASE_URL + suffix
    # puts url
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    html_doc.search('.thumb-link').each_with_index do |element, index|
      full_link = element.attribute('href').value
      full_links << full_link if index < 3
    end
    return full_links
  end

  def scrap_2(full_links) #array
    articles = []
    full_links.each do |full_link|
      article = {}
      url = full_link

      article[:url] = url

      html_file = open(url).read
      html_doc = Nokogiri::HTML(html_file)

      images = []
      html_doc.search('.product-image-link').each do |element|
        image_url = element.attribute('href').value
        images << image_url
      end
      article[:images] = images

      html_doc.search('.product-content .name').each do |element|
        title = element.text.strip
        article[:title] = title
      end

      price_plain = 0
      price_decimal = 0
      html_doc.search('.pricePlain').each do |element|
        price_plain = element.text.strip
        price_plain = price_plain.to_i*100
      end
      html_doc.search('.price-decimal').each do |element|
        price_decimal = element.text.strip
        price_decimal = price_decimal.to_i
      end
      price = price_plain + price_decimal
      article[:price] = price


      description = 'Très tendance pour cet été !'
      article[:description] = description
      # html_doc.search('.product-desc-content span').each_with_index do |element, index|
      #   p element
      #   if index === 0
      #     description = element.text.strip
      #     article[:description] = description
      #   end
      # end

      size_stock = {}
      html_doc.search('.va-size li').each do |element|
        size = element.text.strip
        size_stock[size] = true
      end
      article[:size_stock] = size_stock

      articles << article
    end
    return articles
  end

end

# service = JulesScrappingService.new(['polo','bleu'])
# service.call
