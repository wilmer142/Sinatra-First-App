require 'sinatra'
require 'faker'
require 'pry'
require 'sinatra/flash'
require 'base64'

enable :sessions

include Faker

get '/' do
	authorize ? (erb :index) : (erb :login)
end

get '/greet' do
  authorize ? ("Hola #{params[:name]} hoy es #{params[:dia]}") : (erb :login)
end

get '/home' do
	if authorize
		@params = {name: params[:name], dia: params[:dia], clase: params[:clase]}
		erb :home
	else
		erb :login
	end
end

get '/contact/:name' do
	if authorize
		@cualquiercosa = params[:name]
		erb :contact
	else
		erb :index
	end
end

get '/contact' do
	authorize ? (erb :contact) : (erb :login)
end

get '/about' do
	authorize ? (erb :about) : (erb :login)
end

get '/triangulo' do
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

get '/sign_in' do
	erb :sign_in
end

post '/sign_in' do
	if !user_exist?(@params[:username])
		user = ["#{params[:username]},#{params[:email]},#{params[:password]}"]
		write_to_file(user,"users.txt")
		response.set_cookie("username", value: params[:username])
		flash[:success] = "Usuario registrado exitosamente!"
		redirect "/"
	else
		flash[:danger] = "El username ingresado ya existe"
		redirect "/sign_in"
	end
end

get '/name' do
	@persons = {name: params[:name], surname: params[:surname], email: params[:email]}
	erb :name
end

get '/torneo' do
	@characters = []
	10.times do
		@characters.push(DragonBall.character)
	end
	erb :torneo
end

get '/login' do
	erb :login
end

post '/login' do
	if login(params[:username], params[:password])
		response.set_cookie("username", value: params[:username])
		flash[:success] = "Inicio de sesión exitoso"
		redirect "/"
	else
		flash[:warning] = "Usuario o contraseña incorrecta"
		redirect "/login"
	end
end

get '/logout' do
	response.delete_cookie("username")
	flash[:info] = "Sesión cerrada correctamente"
	redirect "/login"
end

def authorize
	request.cookies["username"]
end

def write_to_file(line, my_file)
  File.open(my_file, 'a') do |file|
  	user = line[0].chomp.split(",")
  	password_encode = Base64.encode64(user[2])
 		file.puts "#{user[0]},#{password_encode.chomp},#{user[1]}\n"
  end
end

def login(username, password)
	file = File.readlines('users.txt')
	file.each do |user|
		user = user.chomp.split(",")
		password_decode = Base64.decode64(user[1])
		return true if user[0] == username && password_decode == password
	end
	return false
end

def user_exist?(username)
	file = File.readlines('users.txt')
	file.each do |user|
		user = user.chomp.split(",")
		return true if user[0] == username
	end
	return false
end