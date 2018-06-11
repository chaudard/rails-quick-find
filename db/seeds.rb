def fill_schedules_stores_table(scrapping_stores, provider)
  scrapping_stores.each_with_index do |scrapping_store, index|
    if Store.where(address: scrapping_store[:address]).count == 0 #pour éviter les doublons
      store = Store.new
      store.name = scrapping_store[:name]
      store.address = scrapping_store[:address]
      store.phone = scrapping_store[:phone]
      store.provider = provider
      store.save!
      puts "store #{index} saved"
      # record schedules
      scrapping_store[:horaires].each do |day, horaire|
        schedule = Schedule.new
        schedule.name = day
        schedule.open_hours = horaire
        schedule.store = store
        schedule.save!
        puts "schedule saved"
      end
    end
  end
end


# puts 'destroy store, provider if development'
if Rails.env = 'development'
  # Provider.destroy_all
end

provider_celio=Provider.where(name: 'celio').first
provider_jules=Provider.where(name: 'jules').first
provider_izac=Provider.where(name: 'izac').first

puts 'start creating providers'
if provider_celio.nil?
  puts 'provider celio'
  provider_celio = Provider.new
  provider_celio.name = 'celio'
  provider_celio.logo = 'https://upload.wikimedia.org/wikipedia/commons/c/c6/Logo_celio_2016.svg'
  provider_celio.website = 'https://www.celio.com/'
  provider_celio.base_url = 'https://www.celio.com/' #pas utilisé
  provider_celio.save!
end
if provider_izac.nil?
  puts 'provider izac'
  provider_izac = Provider.new
  provider_izac.name = 'izac'
  provider_izac.logo = 'https://medias.oas.io/medias/2018/01/09/17/b44e041807b497c8401b67dd9bcbe068-300x240.jpg'
  provider_izac.website = 'https://www.izac.fr/fr/'
  provider_izac.base_url = 'https://www.izac.fr/fr/' #pas utilisé
  provider_izac.save!
end
if provider_jules.nil?
  puts 'provider jules'
  provider_jules = Provider.new
  provider_jules.name = 'jules'
  provider_jules.logo = 'http://les-zed.com/leszed/images/nouveau-jules.jpg'
  provider_jules.website = 'http://www.jules.com/fr/index'
  provider_jules.base_url = 'http://www.jules.com/fr/index' #pas utilisé
  provider_jules.save!
  puts 'creating providers finished'
end
puts 'finish creating providers'

provider_celio=Provider.where(name: 'celio').first
provider_jules=Provider.where(name: 'jules').first
provider_izac=Provider.where(name: 'izac').first

# big seed of cities
puts 'destroy all stores'
Store.destroy_all # destroy schedules at the same time

start = DateTime.now

puts 'start creating stores'
# s = CitiesScrappingService.new
# french_cities = s.call
french_cities = ["Paris",
                 "Marseille",
                 "Lyon",
                 "Toulouse",
                 "Nice",
                 "Nantes",
                 "Strasbourg",
                 "Montpellier",
                 "Bordeaux",
                 "Lille",
                 "Rennes",
                 "Reims",
                 "Le Havre",
                 "Saint-Etienne",
                 "Toulon",
                 "Grenoble",
                 "Angers",
                 "Dijon",
                 "Brest",
                 "Le Mans",
                 "Nimes",
                 "Aix-en-Provence",
                 "Clermont-Ferrand",
                 "Tours",
                 "Amiens",
                 "Limoges",
                 "Villeurbanne",
                 "Metz",
                 "Besancon",
                 "Perpignan",
                 "Orleans",
                 "Caen",
                 "Mulhouse",
                 "Boulogne-Billancourt",
                 "Rouen",
                 "Nancy",
                 "Argenteuil",
                 "Montreuil",
                 "Saint-Denis",
                 "Roubaix",
                 "Avignon",
                 "Tourcoing",
                 "Poitiers",
                 "Nanterre",
                 "Creteil",
                 "Versailles",
                 "Pau",
                 "Courbevoie",
                 "Vitry-sur-Seine",
                 "Asnieres-sur-Seine",
                 "Colombes",
                 "Aulnay-sous-Bois",
                 "La Rochelle",
                 "Rueil-Malmaison",
                 "Antibes",
                 "Saint-Maur-des-Fosses",
                 "Calais",
                 "Champigny-sur-Marne",
                 "Aubervilliers",
                 "Beziers",
                 "Bourges",
                 "Cannes",
                 "Saint-Nazaire",
                 "Dunkerque",
                 "Quimper",
                 "Valence",
                 "Colmar",
                 "Drancy",
                 "Merignac",
                 "Ajaccio",
                 "Levallois-Perret",
                 "Troyes",
                 "Neuilly-sur-Seine",
                 "Issy-les-Moulineaux",
                 # "Villeneuve-d'Ascq",
                 "Noisy-le-Grand",
                 "Antony",
                 "Niort",
                 "Lorient",
                 "Sarcelles",
                 "Chambery",
                 "Saint-Quentin",
                 "Pessac",
                 "Venissieux",
                 "Cergy",
                 "La Seyne-sur-Mer",
                 "Clichy",
                 "Beauvais",
                 "Cholet",
                 "Hyeres",
                 "Ivry-sur-Seine",
                 "Montauban",
                 "Vannes",
                 "La Roche-sur-Yon",
                 "Charleville-Mezieres",
                 "Pantin",
                 "Laval",
                 "Maisons-Alfort",
                 "Bondy",
                 "Evry"]
french_cities.each do |city|
  unless provider_celio.nil?
    puts "stores celio #{city}"
    service = StoresScrappingService.new('celio',"#{city}")
    scrapping_stores = service.call
    fill_schedules_stores_table(scrapping_stores, provider_celio)
  end
  unless provider_izac.nil?
    puts "stores izac #{city}"
    service = StoresScrappingService.new('izac',"#{city}")
    scrapping_stores = service.call
    fill_schedules_stores_table(scrapping_stores, provider_izac)
  end
  unless provider_jules.nil?
  puts "stores jules #{city}"
    service = StoresScrappingService.new('jules',"#{city}")
    scrapping_stores = service.call
    fill_schedules_stores_table(scrapping_stores, provider_jules)
  end
end
time_difference_in_sec = (DateTime.now.to_time.to_i - start.to_time.to_i).abs
puts "time spent : #{time_difference_in_sec}"
puts 'finished'






