---
layout: post
title:  "Under the Hood: Underscore's bindAll"
date:   2015-03-27 16:36:00
categories: javascript
---

[Underscore.js](http://underscorejs.org/) is one of my favorite javascript libraries. It's like the Standard Library javascript never had. It includes many useful utility functions without monkey patching any built in objects like: `String` or `Array`. It also includes one function commonly used by [Backbone.js](http://backbonejs.org/) users, `bindAll`.

*What it Does?*

`bindAll` is a utility method which forces a list of functions to operate within the desired context. Each function passed to `bindAll` will have it's `this` keyword bound to the object passed in the first argument. Let's see an example:

{% highlight javascript %}

var car = {
  clean: false,
  onWash: function () {
    if (this.clean) console.log("I am clean");
  }
};

function wash(car, onWash) {
    car.clean = true;
    onWash();
}

_.bindAll(car, 'onWash');

wash(car, car.onWash);

{% endhighlight %}

This is a contrived example but it illustrates how easy it is to change the context of a function in Javascript. Without `_.bindAll` the `onWash` callback function's context would be the global scope. So how does `_.bindAll` guarantee that my context will not change?

*How it Works?*



*Interesting Use Cases*
* use the same function across different types
* ajax callbacks
