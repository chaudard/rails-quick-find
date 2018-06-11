require 'open-uri'
require 'nokogiri'

class CitiesScrappingService

  def initialize
  end

  def call
    cities = scrap
    p cities
  end

  private

  def scrap
    cities = []
    url = "http://www.cartesfrance.fr/carte-france-ville/carte-france-villes.html"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    html_doc.search('.liste_ancres_fines > a').each_with_index do |element, index|
      city = element.text.strip
      cities << city
    end
    return cities
  end
end

s = CitiesScrappingService.new
s.call
