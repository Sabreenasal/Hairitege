class ProductsController < ApplicationController
   def import
    Product.import(params[:file])
    redirect_to products_path, notice: "Products imported successfully!"
  rescue => e
    redirect_to products_path, alert: "Import failed: #{e.message}"
  end
end
