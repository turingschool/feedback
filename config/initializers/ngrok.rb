if Rails.env.development?
  ngrok_url = "https://b8665709.ngrok.io"
  Rails.application.routes.default_url_options[:host] = ngrok_url
end
