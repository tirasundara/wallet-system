require "net/http"
require "json"

class LatestStockPrice
  BASE_URL = "https://twelve-data1.p.rapidapi.com"

  def self.configure
    yield self if block_given?
  end

  class << self
    attr_accessor :api_key

    def api_key
      @api_key || ENV["RAPID_API_KEY"]
    end
  end

  def self.price(symbol)
    response = make_request("/quote?symbol=#{symbol}&format=json")
    return nil if response.nil? || response.empty?

    response["close"]
  end

  def self.prices(symbols)
    symbols_param = symbols.join(",")
    response = make_request("/quote?symbol=#{symbols_param}&format=json")
    return {} if response.nil?

    response.each_with_object({}) do |stock, result|
      result[stock[1]["symbol"]] = stock[1]["close"]
    end
  end

  def self.price_all
    symbols = Stock.pluck(:symbol)
    self.prices(symbols)
  end

  private

  def self.make_request(endpoint)
    uri = URI("#{BASE_URL}#{endpoint}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request["x-rapidapi-key"] = api_key
    request["x-rapidapi-host"] = "twelve-data1.p.rapidapi.com"

    response = http.request(request)

    return nil unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  rescue StandardError => e
    Rails.logger.error("LatestStockPrice API error: #{e.message}")
    nil
  end
end
