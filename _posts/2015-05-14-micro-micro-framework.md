---
layout: post
title:  "The \"No Framework\" Framework"
date:   2015-05-14 12:15:00
categories: ruby api
---

Web development is changing. There is a massive push toward building REST APIs that communicate with a wide variety of clients and other APIs. This will forever change the way we structure our web applications and what frameworks we use to build them. So when starting from scratch, what is the best framework for building a modern web application?

I would argue that sometimes the best framework is no framework at all. Many frameworks are monolithic with more features than the average REST API will ever need or use. Not using a framework forces us to decide which parts we actually need instead of just installing a pile of dependencies.

So how can a web application be constructed without a framework? By starting where the framework itself started. In this case my example will be in Ruby and at the core of the many popular Ruby Frameworks (Rails, Sinatra, etc) is [Rack](http://rack.github.io/).

Rack is a simple library that allows developers to interface with a variety of webservers in the Ruby ecosystem. Here is the "Hello World" of a web application built with Rack:

{% highlight ruby %}

require 'rack'

hello_world = Proc.new do |env|
  ['200', {'Content-Type' => 'text/html'}, ['Hello World!']]
end

Rack::Handler::WEBrick.run hello_world

{% endhighlight %}

Now if I open a browser and visit localhost:8080 it will respond with "Hello World".

Rack may be a long way from being as full featured as something like [Sinatra](http://www.sinatrarb.com/) but it is full of plugin middleware modules to make web applications more useful. I am a big fan of this as it adheres to the [unix philosophy](http://en.wikipedia.org/wiki/Unix_philosophy) and makes adding additional functionality easy and optional. Rails uses this feature of Rack [extensively](http://guides.rubyonrails.org/rails_on_rack.html#internal-middleware-stack).

So what would a small Rack REST API look like? Here is an example of one that returns a JSON response of any GET parameters it is passed:

{% highlight ruby %}

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

{% endhighlight %}

This obviously isn't production ready but it at least shows an example of how to get started building a simple REST API without a heavy framework.
