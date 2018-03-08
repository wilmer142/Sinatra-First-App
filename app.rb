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

get '/triangulo' do

#	"CALCULANDO AREA DE TRIANGULO"
#	"El lado del triangulo con lados: \n
#	 a) #{params[:ladoa]} \n
#	 b) #{params[:ladob]} \n
#	 es: #{params[:ladoa].to_i * params[:ladob].to_i}"

	@params = {ladoa: params[:ladoa], ladob: params[:ladob]}
	erb :triangulo
end

get '/redirect' do
	status 301
	headers "location" => "https://www.google.com.co"
end

put '/put' do
	status 200
	body "Modificando"
end

delete '/delete' do
	status 200
	body "borrando"
end