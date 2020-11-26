require "http/server"
require "yaml"
require "json"
require "digest/md5"

DEFAULT_LOCALE = "en"
DEFAULT_PORT = 8080

hash = Hash(String, YAML::Any).new

Dir.glob("**/locales/*.yml") do |file|
    current_locale = File.basename(file, File.extname(file))
    yaml = File.open(file.to_s) { |content| hash[current_locale.to_s] = YAML.parse(content) }
end

server = HTTP::Server.new do |context|
    params = context.request.query_params

    locale = params["locale"]? ? params["locale"]? : DEFAULT_LOCALE

    hash_locale = hash.keys.includes?(locale) ? hash[locale].as_h : hash[DEFAULT_LOCALE].as_h
    random_question = Random.new.rand(0..hash_locale.keys.size - 1)
    current_question = hash_locale.keys[random_question]

    md5_answers = [] of String | Int32

    hash_locale[current_question].as_a.each do |answer|
        md5_answers << Digest::MD5.hexdigest(answer.to_s)
    end

    response = { current_question.to_s => md5_answers }

  context.response.content_type = "application/json"
  context.response.print response.to_json
end

port = ENV.has_key?("PORT") ? ENV["PORT"].to_i : DEFAULT_PORT

address = server.bind_tcp("0.0.0.0", port)
puts "Listening on http://#{address}"
server.listen
