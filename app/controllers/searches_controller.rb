class SearchesController < ApplicationController
  def new
    @search = Search.new
  end

  def create
    # @search = Search.new
    @search = Search.where(keywords: params["keywords"]).first
    if @search.nil?  #pas besoin de scraper si rech existe déjà
      @search = Search.new(params_search)
      # @search.input_address = params["input_address"]
      # @search.keywords = params["keywords"]
      # @search.distance = params["distance"]
      @search.save!
      search_array = params["keywords"].split
      scraps = []
      scraps << IzacScrappingService.new(search_array).call
      scraps << JulesScrappingService.new(search_array).call
      scraps <<  CelioScrappingService.new(search_array).call
      # scrap articles for each enseigne
      scraps.each do |scrap|
        scrap.each do |enseigne|
          create_article(enseigne)
        end
      end
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

  def create_article(sku)
    @article = Article.new
    @article.url = sku[:url]
    @article.title = sku[:title]
    @article.description = sku[:description]
    @article.price = sku[:price].to_i
    @article.search = @search
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
end

def params_search
  params.require(:search).permit(:input_address, :distance, :keywords)
end
