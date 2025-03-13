module Api
  module V1
    class StocksController < ApplicationController
      def index
        stocks = Stock.all
        render json: stocks
      end

      def show
        stock = Stock.find_by!(symbol: params[:symbol].to_s.upcase)

        # Update price using the LatestStockPrice library
        price = LatestStockPrice.price(stock.symbol)
        stock.update(current_price: price) if price

        render json: stock.as_json(include: { wallet: { only: [ :id, :balance ] } })
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Stock not found" }, status: :not_found
      end
    end
  end
end
