class SearchesController < ApplicationController
  def new
    @search = Search.new
  end

  def create_new_search(city)
      @search = Search.new(params_search)
      @search.city = city
      @search.save
  end

  def create
    city = find_city(params["input_address"])

    provider_celio=Provider.where(name: 'celio').first
    provider_jules=Provider.where(name: 'jules').first
    provider_izac=Provider.where(name: 'izac').first



    @search = Search.where(city: city).first
    if @search.nil?

      create_new_search(city)

      service = StoresScrappingService.new('celio',params["input_address"])
      scrapping_stores = service.call
      fill_schedules_stores_table(scrapping_stores, provider_celio)

      service = StoresScrappingService.new('jules',params["input_address"])
      scrapping_stores = service.call
      fill_schedules_stores_table(scrapping_stores, provider_jules)

      service = StoresScrappingService.new('izac',params["input_address"])
      scrapping_stores = service.call
      fill_schedules_stores_table(scrapping_stores, provider_izac)
    end

    @search = Search.where(keywords: params["keywords"]).first
    if @search.nil?  #pas besoin de scraper si rech existe déjà

      create_new_search(city)

      search_array = params["keywords"].split

      # scraps = []
      # scraps << IzacScrappingService.new(search_array).call
      # scraps << JulesScrappingService.new(search_array).call
      # scraps <<  CelioScrappingService.new(search_array).call
      # # scrap articles for each enseigne
      # scraps.each do |scrap|
      #   scrap.each do |enseigne|
      #     create_article(enseigne)
      #   end
      # end

      # association des articles avec un provider

      # celio
      scrap = CelioScrappingService.new(search_array).call
      scrap.each do |enseigne|
        create_article(enseigne, provider_celio)
      end

      # jules
      scrap = JulesScrappingService.new(search_array).call
      scrap.each do |enseigne|
        create_article(enseigne, provider_jules)
      end

      # izac
      scrap = IzacScrappingService.new(search_array).call
      scrap.each do |enseigne|
        create_article(enseigne, provider_izac)
      end

      # ------------------------------------

    else
      @search.input_address = params["input_address"]
      @search.distance = params["distance"]
      @search.save
    end

    @articles = @search.articles
    #maps feed with store
    # @stores = Store.where.not(latitude: nil, longitude: nil)
    # @markers = @stores.map { |store| {lat: store.latitude, lng: store.longitude} }

    redirect_to search_articles_path(@search)
  end

  def index

  end


  private

  def create_article(sku, provider)
    @article = Article.new
    @article.url = sku[:url]
    @article.title = sku[:title]
    @article.description = sku[:description]
    @article.price = sku[:price].to_i
    @article.search = @search
    @article.provider = provider
    if @article.save!
      fill_images(sku[:images]) if sku[:images] != nil
      fill_stock(sku[:size_stock]) if sku[:size_stock] != nil
    end
  end

  def fill_images(images)
    images.each do |image|
      @image = Image.new
      @image.url = image
      @image.article = @article
      @image.save!
    end
  end

  def fill_stock(size_stock)
    size_stock.each do |size, available|
      @stock = Stock.new
      @stock.size = size
      @stock.available = available
      @stock.article = @article
      @stock.save!
    end
  end

  def fill_schedules_stores_table(scrapping_stores, provider)
    scrapping_stores.each_with_index do |scrapping_store, index|
      store = Store.new
      store.name = scrapping_store[:name]
      store.address = scrapping_store[:address]
      store.phone = scrapping_store[:phone]
      store.provider = provider
      store.save
      # puts "store #{index} saved"
      # record schedules
      scrapping_store[:horaires].each do |day, horaire|
        schedule = Schedule.new
        schedule.name = day
        schedule.open_hours = horaire
        schedule.store = store
        schedule.save
        # puts "schedule saved"
      end
    end
  end

  # def city(geolocalized_instance)
  #   geo_localization = "#{geolocalized_instance.latitude},#{geolocalized_instance.longitude}"
  #   query = Geocoder.search(geo_localization).first
  #   query.city
  # end

  def find_city(input_address)
    query = Geocoder.search(input_address).first
    query.city
  end

end

def params_search
  params.permit(:input_address, :distance, :keywords)
end
