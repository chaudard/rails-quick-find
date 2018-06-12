class SearchesController < ApplicationController
  def new
    @search = Search.new
  end

  def create

    provider_celio=Provider.where(name: 'celio').first
    provider_jules=Provider.where(name: 'jules').first
    provider_izac=Provider.where(name: 'izac').first

#plus nécessaire si on fait le big seed de tous les stores de france

    # @search = Search.where(city: params[:city]).first
    # if @search.nil?

    #   # create_new_search(city)

    #   # demande de gab d'enlever 2 scraps / 3 afin d'éviter le time out

    #   # service = StoresScrappingService.new('celio',params["input_address"])
    #   # scrapping_stores = service.call
    #   # fill_schedules_stores_table(scrapping_stores, provider_celio)

    #   # service = StoresScrappingService.new('jules',params["input_address"])
    #   # scrapping_stores = service.call
    #   # fill_schedules_stores_table(scrapping_stores, provider_jules)

    #   service = StoresScrappingService.new('izac',params["input_address"])
    #   scrapping_stores = service.call
    #   fill_schedules_stores_table(scrapping_stores, provider_izac)
    # end

    @search = Search.where(keywords: params["keywords"]).first
    if @search.nil?  #pas besoin de scraper si rech existe déjà


      @search = Search.create(params_search)

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
      unless provider_celio.nil?
        scrap = CelioScrappingService.new(search_array).call
        scrap.each do |enseigne|
          create_article(enseigne, provider_celio)
        end
      end

      # izac
      unless provider_izac.nil?
        scrap = IzacScrappingService.new(search_array).call
        scrap.each do |enseigne|
          create_article(enseigne, provider_izac)
        end
      end

      # jules
      unless provider_jules.nil?
        scrap = JulesScrappingService.new(search_array).call
        scrap.each do |enseigne|
          create_article(enseigne, provider_jules)
        end
      end

      # ------------------------------------

    else
      @search.input_address = params["input_address"]
      @search.distance = params["distance"]
       # fail
      @search.save
    end

    @articles = @search.articles
    #maps feed with store
    # @stores = Store.where.not(latitude: nil, longitude: nil)
    # @markers = @stores.map { |store| {lat: store.latitude, lng: store.longitude} }

    redirect_to search_articles_path(@search)
    # fail
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
end

def params_search
  params.permit(:input_address, :distance, :keywords, :city)
end
