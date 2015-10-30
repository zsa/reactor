require 'sinatra'

configure { set :server, :puma }

post '/' do
	  "Hello World!"
end
