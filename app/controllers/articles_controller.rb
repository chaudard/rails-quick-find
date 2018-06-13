require 'json'
require 'open-uri'

class ArticlesController < ApplicationController
  before_action :set_search_and_near_stores, only: [:index, :show]

  include ActionView::Helpers::NumberHelper

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

  def sort_markers_stores
    hash_distances = {}
    @markers_stores.each_with_index do |store, index|
      distance = Geocoder::Calculations.distance_between([store.latitude,store.longitude],[@search.latitude,@search.longitude])
      hash_distance = {}
      hash_distance[:store] = store
      hash_distance[:distance] = distance
      hash_distances[index.to_s] = hash_distance
    end
    sort_results = hash_distances.sort_by { |k, v| v[:distance] }
    @markers_stores = []
    @markers_distances = []
    sort_results.each do |sort_result|
      @markers_stores << sort_result[1][:store]
      @markers_distances << sort_result[1][:distance]
    end
  end

  def distance_and_travel_times(store)
    travel_modes = ['driving', 'walking', 'bicycling', 'transit']
    travel_datas = {}
    travel_modes.each do |mode|
      url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=km&origins=#{@search.latitude},#{@search.longitude}&destinations=#{store.latitude},#{store.longitude}&mode=#{mode}&key=#{ENV['GOOGLE_API_SERVER_KEY']}"
      response_serialized = open(url).read
      response = JSON.parse(response_serialized)
      distance = 0
      distance = response["rows"][0]["elements"][0]["distance"]["text"] if response["rows"][0]["elements"][0]["distance"]
      travel_time = 0
      travel_time = response["rows"][0]["elements"][0]["duration"]["text"] if response["rows"][0]["elements"][0]["duration"]
      travel_mode_response = {}
      travel_mode_response['distance'] = distance
      travel_mode_response['time'] = travel_time
      travel_datas[mode] = travel_mode_response
    end
    return travel_datas
  end

  def compute_stores_and_markers(search, stores, article)
    stock_stores = []
    @stores = Store.find(stores.sort.uniq)
    stock_stores = @stores && @near_stores
    unless article.nil?
      stock_stores = stock_stores.select {|s| s.provider == article.provider}
    end

    @markers = []
    @markers_stores = [] #les stores qui auront un marker sur la map
    # Fill Gmaps with stores having stock
    # @markers = @stores.map { |store| {lat: store.latitude, lng: store.longitude} }
    stock_stores.each do |store|
      next if store.provider == nil
      next if store.provider.articles == nil
      @markers_stores << store
    end

    # faisons un tri des @markers_stores, de manière à les lister du plus proche au plus éloigné

    sort_markers_stores

    @markers_stores.each_with_index do |store, index|
      @start = []
      @start << { lat: @search.latitude, lng: @search.longitude }

      distance = 0 #@markers_distances[index]

      travel_datas = distance_and_travel_times(store)

      @markers << {lat: store.latitude,
                   lng: store.longitude,
                   distance: distance,          # distance provenant du geocoder de ruby (à vol d'oiseau ) (!!! ne pas utiliser dans le js !!!)
                   traveldatas: travel_datas,   # informations qui viennent de l'api de google et qui donnent les détails pour chaque mode de transport
                   phone: store.phone,
                   address: store.address,
                   title: store.name,
                   enseigne: store.provider.name,
                   logo: store.provider.logo,
                   schedules: store.schedules,
                   posinlist: index,
                   # icon: 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png'
                   icon: 'https://findicons.com/files/icons/951/google_maps/32/clothes.png' # https://findicons.com/pack/951/google_maps/7
                  }
    end

  end

  def params_article
    params.require(:article).permit(:title, :sku, :description, :price, :selected)
  end
end
