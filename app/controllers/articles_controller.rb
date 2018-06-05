class ArticlesController < ApplicationController
  def index
  end

  def show
  end


  private

  def params_article
    params.require(:article).permit(:title, :sku, :description, :price, :selected)
  end
end
