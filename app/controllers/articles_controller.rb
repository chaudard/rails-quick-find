class ArticlesController < ApplicationController
  before_action :set_search_and_near_stores, only: [:index, :show]

  def index
    # listons les providers qui se trouvent dans le rayon de recherche
    near_stores_providers = []
    @near_stores.each do |store|
      near_stores_providers << store.provider if !near_stores_providers.include?(store.provider)
    end
    # prendre les articles qui ont du stock et dont le fournisseur a un store à proximité
    @articles = @search.articles.select { |a| a.stocks.map { |s| s.available}.include?(true) && near_stores_providers.include?(a.provider)}
    return false if @articles == nil

    stores = []

    #find stores from enseigne with articles with stock
    @articles.each do |article|
      article.provider.stores.each do |store|
        stores << store[:id]
      end
    end
    compute_stores_and_markers(@search, stores, nil)
    @providers = Provider.all
    @provider = params[:provider]
  end

  def show
    @article = Article.find(params[:id])
    stores = []
    @article.provider.stores.each do |store|
      stores << store[:id]
    end
    compute_stores_and_markers(@search, stores, @article)
    @select_prix = params[:select_prix]
    @store = []
    @start = []
    @store << { lat: @markers.first[:lat], lng: @markers.first[:lng]}
    @start << { lat: @search.latitude, lng: @search.longitude }
  end


  private

  def set_search_and_near_stores
    @search = Search.find(params[:search_id])
    @near_stores = []
    near_stores = Store.near(@search.input_address, @search.distance, units: :km)
                       .where.not(latitude: nil, longitude: nil)
    near_stores.each do |store|
      @near_stores << store
    end
  end

  def compute_stores_and_markers(search, stores, article)
    stock_stores = []
    @stores = Store.find(stores.sort.uniq)
    stock_stores = @stores && @near_stores
    unless article.nil?
      stock_stores = stock_stores.select {|s| s.provider == article.provider}
    end
    # fail
    @markers = []
    @markers_stores = [] #les stores qui auront un marker sur la map
    # Fill Gmaps with stores having stock
    # @markers = @stores.map { |store| {lat: store.latitude, lng: store.longitude} }
    stock_stores.each do |store|
      next if store.provider == nil
      next if store.provider.articles == nil
      @markers_stores << store
      @markers << {lat: store.latitude,
                   lng: store.longitude,
                   title: store.name,
                   enseigne: store.provider.name,
                   icon: 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png'}
    end
  end

  def params_article
    params.require(:article).permit(:title, :sku, :description, :price, :selected)
  end
end
