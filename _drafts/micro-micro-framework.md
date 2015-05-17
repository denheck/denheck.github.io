---
layout: post
title:  "The \"No Framework\" Framework"
date:   2015-05-14 12:15:00
categories: ruby api
---

Web development is changing. There is a massive push toward building APIs that communicate with a wide variety of clients and other APIs. This will forever change the way we structure our applications and what technologies we use to build them. So when starting from scratch, what is the best framework for building a modern web application?

I would argue the best framework is sometimes no framework at all. Too little structure? Well, maybe that's a good thing. It forces us to decide which parts we actually need instead of just installing a pile of dependencies we may or may not use. Instead we can add modules as we need them. This approach adheres to the [Unix Philosophy](http://en.wikipedia.org/wiki/Unix_philosophy).

So how do you start building a web application without a framework to get you started? You start where the framework itself started. In this case my example will be in Ruby and at the core of the many popular Ruby Frameworks (Rails, Sinatra, etc) is [Rack](http://rack.github.io/).

Rack is a simple library that allows you to interface with a variety of webservers in the Ruby ecosystem. Here is the "Hello World" of a web application built with Rack:

{% highlight ruby %}

require 'rack'

hello_world = Proc.new do |env|
  ['200', {'Content-Type' => 'text/html'}, ['Hello World!']]
end

Rack::Handler::WEBrick.run hello_world

{% endhighlight %}

Now if I open a browser and visit localhost:8080, or wherever you have configured your Webrick server to run, it will respond with "Hello World". This may be a long way from being as full featured as something like [Sinatra](http://www.sinatrarb.com/) but Rack is full of plugable modules to make your web application more useful.

Here is an example of a simple API that returns a JSON response of the GET parameters it is passed:

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

Rack may not be a new and exciting framework but it is simple, modular and practical.
