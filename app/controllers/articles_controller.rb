class ArticlesController < ApplicationController
  def index
    @articles = Article.all
    # @articles = Article.where.not(latitude: nil, longitude: nil)

    # @markers = @articles.map do |article|
    #   {
    #     lat: flat.latitude,
    #     lng: flat.longitude
    #   }
    # end

  end

  def show
    @article = Article.find(params[:id])
  end


  private

  def params_article
    params.require(:article).permit(:title, :sku, :description, :price, :selected)
  end
end
