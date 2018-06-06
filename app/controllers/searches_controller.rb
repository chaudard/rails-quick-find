class SearchesController < ApplicationController
  def new
    @search = Search.new
  end

  def create
    search_array = params["keywords"].split
    articles = IzacScrappingService.new([search_array])
    articles.each do |article|
      create_article(article)
    end
  end

  def index
  end


  private

  def create_article(article)
    @article = Article.find_or_create_by(url: article[:url])
    if @article.new_record?
      # @article.url = article[:url]
      @article.title = article[:title]
      @article.description = article[:description]
      @article.price = article[:price].to_i
      @article.save
      fill_images
      fill_stock
    else
      return false
    end

  end

  def fill_images
      @article[:images].each do |image|
      @image = Image.new
      if @image.new_record?
        @image.url = image.url
        @image.article = @article
      end
    end
  end

  def fill_stock
    article[:size_stock].each do |size, stock|
      @stock = Stock.new
      @stock.size = size
      @stock.stock = stock
      @stock.article = @article
    end
  end
end
