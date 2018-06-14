class ApplicationController < ActionController::Base
  def default_url_options
  { host: ENV["HOST"] || "localhost:3000" }
  end
end
