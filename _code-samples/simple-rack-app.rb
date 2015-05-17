require 'rack'

class JsonMiddleware
  def self.set_json_parser(json_parser)
    @@json_parser = json_parser
  end

  def initialize(app)
    @app = app
  end

  def call(env)
    @status, @headers, @body = @app.call(env)
    [@status, @headers, [json_encoded_body]]
  end

  def json_encoded_body
    @@json_parser.encode(@body.shift)
  end
end

class App
  def call(env)
    request = Rack::Request.new(env)
    [200, {'Content-Type' => 'application/json'}, [request.GET]]
  end
end

JsonMiddleware.set_json_parser(Rack::Utils::OkJson)

app = Rack::Builder.new do
  use JsonMiddleware

  map "/jsonify" do
    run App.new
  end
end

Rack::Handler::WEBrick.run app
