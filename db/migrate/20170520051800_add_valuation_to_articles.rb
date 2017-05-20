class AddValuationToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :valuation, :decimal, :precision => 10, :scale => 2
  end
end
