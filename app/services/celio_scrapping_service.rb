require 'open-uri'
require 'nokogiri'

class CelioScrappingService
  BASE_URL = "https://www.celio.com/search/?text=";
  SITE_URL = "https://www.celio.com"

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
      suffix += '+' if index < @keywords.size-1
    end
    url = BASE_URL + suffix
    # puts url
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    html_doc.search('.c-product-v2-fullLink').each_with_index do |element, index|
      full_link = SITE_URL + element.attribute('href').value
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

      # fonctionne mais inutile
      # sku = url.split('/').last
      # article[:sku] = sku

      html_file = open(url).read
      html_doc = Nokogiri::HTML(html_file)

      images = []
      html_doc.search('.c-prod_img_asset a').each do |element|
        image_url = SITE_URL + element.attribute('href').value
        images << image_url
      end
      article[:images] = images

      html_doc.search('.c-prod_description_title').each do |element|
        title = element.text.strip
        article[:title] = title
      end

      html_doc.search('.c-product_price').each do |element|
        price = element.text.strip
        price = price.split[0].to_f*100
        price = price.floor
        article[:price] = price
      end

      html_doc.search('.c-product-desc_col p').each_with_index do |element, index|
        if index === 0
          description = element.text.strip
          article[:description] = description
        end
      end

      size_stock = {}
      html_doc.search('.c-js-taille .choice_option').each do |element|
        size = element.text.strip
        size_stock[size] = true
      end
      article[:size_stock] = size_stock

      articles << article
    end
    return articles
  end

end

# service = CelioScrappingService.new(['polo','bleu'])
# service.call

