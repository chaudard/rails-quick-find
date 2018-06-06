class RenameSkuInArticlesToUrl < ActiveRecord::Migration[5.2]
  def change
    rename_column :articles, :sku, :url
  end
end
