require 'sinatra'
require 'faker'
require 'pry'

include Faker


get '/' do
	@characters = []
	10.times do
		@characters.push(DragonBall.character)
	end
	erb :index
end


=begin
get '/' do
	status 200
	headers "Content-Type" => "text/html"
	body "hola Mundo"
end
=end

get '/greet' do
	"Hola #{params[:name]} hoy es #{params[:dia]}"
end

get '/home' do
	@params = {name: params[:name], dia: params[:dia], clase: params[:clase]}
	erb :home
end

get '/contact/:name' do
	@cualquiercosa = params[:name]
	erb :contact
end

get '/contact' do
	erb :contact
end

get '/about' do
	erb :about
end