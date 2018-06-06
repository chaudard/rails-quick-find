class SearchesController < ApplicationController
  def new
    @search = Search.new
  end

  def create
    @search = Search.new
    @search.input_address = params["input_address"]
    @search.keywords = params["keywords"]
    @search.distance = params["distance"]
    @search.save!
    search_array = params["keywords"].split
    scraps = []
    scraps << IzacScrappingService.new(search_array).call
    scraps << JulesScrappingService.new(search_array).call
    scraps <<  CelioScrappingService.new(search_array).call

    scraps.each do |scrap|
      scrap.each do |enseigne|
        create_article(enseigne)
      end
    end
    @articles = @search.articles
    redirect_to search_articles_path(@search)

  end

  def index
  end


  private

  def create_article(article)
    @article = Article.new #find_or_create_by(url: article[:url])
    if @article.new_record?
      @article.url = article[:url]
      @article.title = article[:title]
      @article.description = article[:description]
      @article.price = article[:price].to_i
      @article.search = @search
      if @article.save!
        fill_images(article[:images]) if article[:images] != nil
        fill_stock(article[:size_stock]) if article[:size_stock] != nil
      end
    else
      return false
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
