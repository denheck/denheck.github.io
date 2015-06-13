---
layout: post
title:  "Is Ruby Pass by Value?"
date:   2015-04-05 19:28:00
categories: ruby
---

Over the weekend I was working on writing some code for my next blog post when I was tripped up by a nuance of the Ruby language. Consider the following method:

{% highlight ruby %}

characters = "TEST"

def mutate(str)
    mutated_str = str
    mutated_str[rand(mutated_str.size)] = ('a'..'z').to_a.sample

    mutated_str
end

mutate(characters)

{% endhighlight %}

This method works by replacing a character in the provided string with a random letter. In this example the mutated string will go from "TEST" to something like "TEJT" or "TRST". Then the method will return the mutated version of the string

I originally expected this to exclusively change the parameter within the scope of the method. In actuality, it also changes `characters`. If I check the value of `characters` after running the code above it will match the return value of `mutate`, i.e. this is true: `characters == mutate(characters)`.

To make matters worse the following is false:

{% highlight ruby %}

characters = "TEST"

def mutate(str)
    str = "TEJT"
end

mutate(characters) == characters # false

{% endhighlight %}

Why would this happen if Ruby is strictly a pass by value language? After some googling I was able to find a pretty solid [explanation](http://stackoverflow.com/questions/22827566/ruby-parameters-by-reference-or-by-value/22827949#22827949). The following diagram will help explain:

[[Diagram]]

This is a diagram of what happens when the first mutate method is called. A reference to the `characters` object is copied to the `str` parameter which is then copied to the `mutated_str` variable. So now both `characters` and `mutated_str` have references to the same object. Therefore `characters` and `mutated_str` will be considered equal according to `==` even after the object is mutated. This version of the method is more like `mutate!`.

[[Diagram]]

The second mutate method behaves differently. Here `str`, by way of the `=` method, is updated to contain a reference to the new string object `"TEJT"`. That means `characters` is still holding a reference to the original object and `str` is holding a reference to the newly defined string object. This works because in this instance we are changing the variable not the object directly.

I believe the confusion stems from the behavior of the assignment operator (`=`). When assigning a variable to another variable it makes a copy of the first variable's reference and stuffs it in the second variable. Assigning a new object to a variable will result in the variable containing a new reference to a new object. The following code summarizes how this works:

{% highlight ruby %}

# Two variables with a reference to the same object
test = 'str'
test2 = test

test.object_id === test2.object_id # true

# Changing test2 to hold the same string 'str'.
# Even though both variables contain 'str' they are
# different objects interally.
test2 = 'str'

test.object_id === test2.object_id # false

{% endhighlight %}

Although confusing this is an important feature of Ruby. Copying references instead of objects helps [optimize](http://ruby-doc.org/core-2.2.2/Object.html#method-i-object_id) the language.

Now going back to the first mutate method with what we have just learned. What is the best way to avoid mutating the underlying object held by `characters`? One possible solution is to use the `clone` method. Now mutate looks like this:

{% highlight ruby %}

characters = "TEST"

def mutate(str)
    mutated_str = str.clone
    mutated_str[rand(mutated_str.size)] = ('a'..'z').to_a.sample

    mutated_str
end

characters == mutate(characters) # false

{% endhighlight %}

By using `clone` we are guaranteed to not have any side effects when passing `characters` to `mutate`. Now we can safely remove the exclamation point!
