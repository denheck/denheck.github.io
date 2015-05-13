---
layout: post
title:  "Is Ruby Pass by Value?"
date:   2015-04-05 19:28:00
categories: ruby
---

Over the weekend I was working on writing some code for my next blog post related to (LINK) Evolutionary Algorithms when I was tripped up by a nuance of the Ruby language. I was writing code similar to the following:

{% highlight ruby %}

characters = "TEST"

def mutate(str)
    str[rand(str.size)] = ('a'..'z').to_a.sample
    str
end

mutate(characters)

{% endhighlight %}

The mutate method works as expected and returns the mutated version of the value "TEST". It will return something like "TEJT". The gotcha is with the variable characters. If I check the value of characters after running the code above it will match the return value of mutate, i.e. `characters == mutate(characters)`.

This is confusing because the following code is false:

{% highlight ruby %}

characters = "TEST"

def mutate(str)
    str = "TEJT"
end

mutate(characters) == characters

{% endhighlight %}

Why would this happen if Ruby is strictly a pass by value language? After some googling I was able to find a pretty solid [explanation](http://stackoverflow.com/questions/22827566/ruby-parameters-by-reference-or-by-value/22827949#22827949). To summarize, Ruby does pass values to methods but those values are references to an existing object. The following diagram will help explain:

[[Diagram]]

When the first mutate method is called with variable `characters`, the reference is copied into the `str` parameter and the operation mutates the object the reference is pointing to. That means the `characters` variable, which is holding the same reference as before, is pointing to the changed object.

[[Diagram]]

The second mutate method follows the same behavior. The `characters` variable is pointing to a reference which is copied into the parameter `str`. The difference here is `str`, by way of the `=` method is updated to point to a new reference which is pointing to the string `"TEJT"`.

Now the code works as expected!

Sources:
http://stackoverflow.com/questions/22827566/ruby-parameters-by-reference-or-by-value/22827949#22827949
http://stackoverflow.com/questions/1872110/is-ruby-pass-by-reference-or-by-value