class AddCeilingToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :ceiling, :decimal, :precision => 10, :scale => 2
    add_column :articles, :zoning, :text
    add_column :articles, :furnishing, :text
    add_column :articles, :lot, :text
  end
end
