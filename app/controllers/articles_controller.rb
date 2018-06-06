class ArticlesController < ApplicationController
  def index
    def index
    @articles = Article.where.not(latitude: nil, longitude: nil)

    @markers = @articles.map do |article|
      {
        lat: flat.latitude,
        lng: flat.longitude#,
      }
    end
  end

  def show
  end


  private

  def params_article
    params.require(:article).permit(:title, :sku, :description, :price, :selected)
  end
end
