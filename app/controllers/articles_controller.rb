class ArticlesController < ApplicationController
  def index

    search = Search.find(params[:search_id])
    @articles = search.articles
    @stores = Store.near(search.input_address, search.distance).where.not(latitude: nil, longitude: nil)
    # to do : Filtrer les enseignes qui ont au moins 1 article en stock

    # Fill Gmaps
    @markers = @stores.map { |store| {lat: store.latitude, lng: store.longitude} }

  end

  def show
  end


  private

  def params_article
    params.require(:article).permit(:title, :sku, :description, :price, :selected)
  end
end
