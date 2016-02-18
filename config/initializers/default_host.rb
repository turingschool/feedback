if Rails.env.development?
  ngrok_url = "https://484a5bf8.ngrok.io"
  Rails.application.routes.default_url_options[:host] = ngrok_url
else
Rails.application.routes.default_url_options[:host]= "https://turingfeedback.herokuapp.com"
end
