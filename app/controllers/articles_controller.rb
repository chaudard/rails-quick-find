class ArticlesController < ApplicationController
  def index
    search = Search.find(params[:search_id])
    # prendre les articles qui ont du stock
    @articles = search.articles.select { |a| a.stocks.map { |s| s.available}.include?(true) }
    return false if @articles == nil

    stores = []
    near_stores = []
    stock_stores = []

    #find stores from enseigne with articles with stock
    @articles.each do |article|
      article.provider.stores.each do |store|
        stores << store[:id]
      end
    end
    @stores = Store.find(stores.sort.uniq)
    @near_stores = Store.near(search.input_address, search.distance, units: :km).where.not(latitude: nil, longitude: nil)

    @near_stores.each do |store|
      near_stores << store
    end
    stock_stores = @stores && near_stores

    @markers = []

    # Fill Gmaps with stores having stock
    # @markers = @stores.map { |store| {lat: store.latitude, lng: store.longitude} }
    stock_stores.each do |store|
      next if store.provider == nil
      next if store.provider.articles == nil
      @markers << {lat: store.latitude, lng: store.longitude}
    end

  end

  def show
    @article = Article.find(params[:id])
  end


  private

  def params_article
    params.require(:article).permit(:title, :sku, :description, :price, :selected)
  end
end
