require 'open-uri'
require 'nokogiri'

class StoresScrappingService

  def initialize(store, city)
    @store = store
    @city = city
  end

  def call
    name_links = scrap_1
    stores = scrap_2(name_links)
    # p stores
  end

  private

  def scrap_1
    name_links = []
    url = "https://www.au-magasin.fr/recherche/results/?quoi=#{@store}&ou=#{@city}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    html_doc.search('.no-bottom h3 a').each_with_index do |element, index|
      name_link = []
      link = element.attribute('href').value
      name = element.text.strip
      name_link << name
      name_link << link
      name_links << name_link #if index === 30
    end
    return name_links
  end

  def scrap_2(name_links) #array or arrays
    stores = []
    name_links.each do |name_link|
      name = name_link[0]
      link = name_link[1]
      store = {}

      store[:name] = name

      url = link
      html_file = open(url).read
      html_doc = Nokogiri::HTML(html_file)

      html_doc.search('.one-half-responsive .last-column').each_with_index do |element, index|
        if index === 0
          value = element.text
          address = value.gsub('ADRESSE POSTALE','').split(' ').join(' ')
          store[:address] = address
        end
      end

      horaires = {}
      html_doc.search('.horaires > tr').each_with_index do |element, index|
        day = 'day-unknown'
        horaire = '00h00 à 00h00'
        element.search('td').each_with_index do |el, index2|
          day = el.text.strip if index2 === 0
          horaire = el.text.strip if index2 === 1
        end
        horaires[day] = horaire
      end
      store[:horaires] = horaires

      store[:phone] = '0033 0 12 34 56 78'

      stores << store
    end
    return stores
  end
end

#service = StoresScrappingService.new('celio','Lille')
#service.call
