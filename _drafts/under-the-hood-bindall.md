---
layout: post
title:  "Under the Hood: Underscore's bindAll"
date:   2015-03-27 16:36:00
categories: javascript
---

[Underscore.js](http://underscorejs.org/) is one of my favorite javascript libraries. It's like the Standard Library javascript never had. It includes many useful utility functions without monkey patching any built in objects like: `String` or `Array`. It also includes one commonly used function for [Backbone.js](http://backbonejs.org/) users, `bindAll`.

*What it Does?*

`bindAll` is a cross browser implementation forcing a list of functions to operate within the desired context. This basically forces each function in the argument list to use the object provided as the first argument as its `this`. Taking a look at the code makes this more clear:

{% highlight javascript %}
{% endhighlight %}

*How it Works?*
