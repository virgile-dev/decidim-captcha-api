require "http/server"
require "yaml"
require "json"
require "digest/md5"

server = HTTP::Server.new do |context|
    params = context.request.query_params

    locale = params["locale"]? ? params["locale"]? : "en"

    hash = Hash(String, YAML::Any).new

     Dir.glob("src/locales/*.yml") do |file|
        current_locale = File.basename(file, File.extname(file))
            yaml = File.open(file.to_s) do |content|
            parsed = YAML.parse(content)
              if YAML.parse(content).is_a? YAML::Any
                hash[current_locale.to_s] = parsed
              end
            end
        end

    hash_locale = hash[locale].as_h
    random_question = Random.new.rand(0..hash_locale.keys.size - 1)
    current_question = hash_locale.keys[random_question]

    md5_answers = [] of String | Int32

    hash[locale][current_question].as_a.each do |answer|
        md5_answers << Digest::MD5.hexdigest(answer.to_s)
    end

    response = { current_question.to_s => md5_answers }

  context.response.content_type = "application/json"
  context.response.print response.to_json
end

port = if ENV.has_key? "PORT"
            ENV["PORT"].to_i
        else
        8080
    end


address = server.bind_tcp("0.0.0.0", port)
puts "Listening on http://#{address}"
server.listen
