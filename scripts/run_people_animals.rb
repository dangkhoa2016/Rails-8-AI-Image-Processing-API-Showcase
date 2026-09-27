# frozen_string_literal: true

require "json"
require "net/http"
require "securerandom"
require "uri"
require "fileutils"

ROOT = File.expand_path("..", __dir__)
OUT = File.join(ROOT, "assets", "output")
FileUtils.mkdir_p(OUT)

class Client
  attr_accessor :token

  def initialize(base)
    @base = base.sub(%r{/+\z}, "")
  end

  def json_post(path, payload, timeout: 60)
    uri = URI(@base + path)
    req = Net::HTTP::Post.new(uri)
    req["Content-Type"] = "application/json"
    req.body = JSON.generate(payload)
    perform(uri, req, timeout)
  end

  def multipart(path, image_path:, fields:, timeout: 300)
    uri = URI(@base + path)
    boundary = "----rails8-showcase-#{SecureRandom.hex(16)}"
    body = +""
    fields.each do |name, value|
      body << "--#{boundary}\r\n"
      body << "Content-Disposition: form-data; name=\"#{name}\"\r\n\r\n"
      body << value.to_s << "\r\n"
    end
    body << "--#{boundary}\r\n"
    body << "Content-Disposition: form-data; name=\"image\"; filename=\"#{File.basename(image_path)}\"\r\n"
    body << "Content-Type: image/jpeg\r\n\r\n"
    body << File.binread(image_path)
    body << "\r\n--#{boundary}--\r\n"

    req = Net::HTTP::Post.new(uri)
    req["Content-Type"] = "multipart/form-data; boundary=#{boundary}"
    req["Authorization"] = "Bearer #{@token}" if @token
    req.body = body
    perform(uri, req, timeout)
  end

  private

  def perform(uri, req, timeout)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https",
                    open_timeout: 15, read_timeout: timeout, write_timeout: timeout) do |http|
      http.request(req)
    end
  end
end

def save!(name, response)
  unless response.code.to_i == 200
    abort "#{name}: HTTP #{response.code} #{response.body.to_s.byteslice(0, 400)}"
  end
  path = File.join(OUT, name)
  File.binwrite(path, response.body)
  puts "#{name}=PASS bytes=#{File.size(path)}"
end

base = ENV.fetch("BASE_URL")
email = ENV.fetch("E2E_EMAIL")
password = ENV.fetch("E2E_PASSWORD")

client = Client.new(base)
login = client.json_post("/users/sign_in", {user: {email: email, password: password}})
abort "login: HTTP #{login.code}" unless login.code.to_i == 200
client.token = JSON.parse(login.body).fetch("token")
puts "LOGIN=PASS"

person = File.join(ROOT, "assets", "input", "person-smiling-cc0-1280.jpg")
dog = File.join(ROOT, "assets", "input", "dog-puppy-white-cc0-1280.jpg")
horse = File.join(ROOT, "assets", "input", "horse-white-cc0-1280.jpg")

save!("person-transparent.png",
  client.multipart("/images/remove-background", image_path: person,
    fields: {"output"=>"transparent","format"=>"png","feather"=>"0"}))

save!("person-soft-background.png",
  client.multipart("/images/remove-background", image_path: person,
    fields: {"output"=>"transparent","format"=>"png","background"=>"#F4F1EA","feather"=>"3"}))

save!("person-box-mask.png",
  client.multipart("/images/segment", image_path: person,
    fields: {"prompt"=>JSON.generate({type:"box",x0:75,y0:155,x1:805,y1:1260})}))

save!("dog-point-mask.png",
  client.multipart("/images/segment", image_path: dog,
    fields: {"prompt"=>JSON.generate({type:"point",x:426,y:660,label:1})}))

save!("dog-box-mask.png",
  client.multipart("/images/segment", image_path: dog,
    fields: {"prompt"=>JSON.generate({type:"box",x0:90,y0:250,x1:760,y1:1135})}))

save!("horse-point-mask.png",
  client.multipart("/images/segment", image_path: horse,
    fields: {"prompt"=>JSON.generate({type:"point",x:500,y:650,label:1})}))

save!("horse-box-mask.png",
  client.multipart("/images/segment", image_path: horse,
    fields: {"prompt"=>JSON.generate({type:"box",x0:220,y0:180,x1:790,y1:1230})}))

puts "PEOPLE_ANIMALS_SHOWCASE=PASS"
