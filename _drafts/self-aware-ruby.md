---
layout: post
title: "Self Aware Ruby"
date: 2016-09-11
categories: ruby metaprogramming
---

One of my favorite aspects of the Ruby programming language is it's emphasis on metaprogramming. I like to think of Ruby as a self-aware programming language. There are several tools available as part of Ruby's standard library that make it easy to manipulate the language at runtime. One module in particular allows users to extract information about all "living" objects in a running Ruby environment. This module is called ObjectSpace.

[ObjectSpace](http://ruby-doc.org/core-2.3.1/ObjectSpace.html) communicate with the Ruby's garbage collector adding support for object traversal, finalizers, reference aquisition and garbage collection itself. Starting with an example of object traversal:

{% highlight ruby %}

ObjectSpace.each_object(Float).to_a
# => [NaN, Infinity, 1.7976931348623157e+308, 2.2250738585072014e-308]

{% endhighlight %}

The `each_object` method accepts an optional module or class to filter the set of objects in the environment and returns an Enumerator. It also accepts a block to iterate over the objects directly. When I ran this in IRB I got back a list of Float instances available at runtime. Let's see how it changes as I add more code:

{% highlight ruby %}

class Foobar
  def to_s
    "Foobar"
  end
end

foobar = Foobar.new

ObjectSpace.each_object(Foobar).to_a
# => [#<Foobar:0x007f8f5a83fa68>]

{% endhighlight %}

Neat, after creating a new instance of the class `Foobar` it is made available to ObjectSpace. What's really cool is we can grab the object from ObjectSpace directly and use it: 

{% highlight ruby %}

ObjectSpace.each_object(Foobar).detect{|object| object === foobar}.to_s
# => "Foobar"

{% endhighlight %}

This is a perfect time to segway into another method that helps grab object references, `_id2ref`:

{% highlight ruby %}

ObjectSpace._id2ref(foobar.object_id).to_s
# => "Foobar"

{% endhighlight %}

This method allows you to grab an object from ObjectSpace by it's unique id. 

Now what about the Foobar class? Since everything in Ruby is an object does that mean that Foobar is also in ObjectSpace? 

{% highlight ruby %}

ObjectSpace._id2ref(Foobar.object_id).new.to_s
# => "Foobar"

{% endhighlight %}

Since Ruby is built entirely on objects, ObjectSpace turns out to be a great way to look for any object reference in a running program, including classes.

Now on to object finalizers and manual garbage collection. Finalizers are a way to hook directly into the lifecycle of a ruby object and call a Proc when that object is destroyed. Here is an example:

{% highlight ruby %}

ObjectSpace.define_finalizer(foobar){ puts "Instance of Foobar is destroyed" }

{% endhighlight %}

After passing the block as an argument to define_finalizer we should see it called once I destroy some objects. 

{% highlight ruby %}

foobar = nil
ObjectSpace.garbage_collect

{% endhighlight %}

This will print "Instance of Foobar is destroyed" but before it does I need to set foobar to nil and force the garbage collector to do it's thing. 

This is just a quick list of some of the interesting features of ObjectSpace.
