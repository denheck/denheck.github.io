---
layout: post
title:  "Under the Hood: Underscore's bindAll"
date:   2015-09-04 08:45:00
categories: javascript
---

[Underscore.js](http://underscorejs.org/) is one of my favorite javascript libraries. It's like the Standard Library javascript never had. It includes many useful utility functions without monkey patching any built in objects like: `String` or `Array`. It also includes one function commonly used by [Backbone.js](http://backbonejs.org/) users, `bindAll`.

###What it Does

`bindAll` is a utility method which forces a list of functions to operate within a desired context. Each function passed to `bindAll` will have it's `this` keyword bound to the object passed in the first argument. Let's see an example:

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

The code above will print "I am clean" to the console. This is a contrived example but it illustrates how easy it is to change the context of a function in Javascript without realizing it. Without `bindAll` the `onWash` callback function's context would be the global scope and `this.clean` would actually refer to `window.clean`. So how does `bindAll` guarantee that my context will not change?

###How it Works

`bindAll` basically works like `bind` but in bulk and the first argument is the context you want to bind the following arguments to. `bindAll` is variadic and all additional arguments are strings matching property names on the object passed as the first argument. Here is a quick example of the source:

{% highlight javascript %}

function bindAll() {
  var args = Array.prototype.slice.apply(arguments);
  var object = args[0];

  // replace functions on object with bound functions
  for (var i = 1; i < args.length; i++) {
    var functionName = args[i];
    object[functionName] = object[functionName].bind(object);
  }
}

{% endhighlight %}

###Why this is useful

When dealing with DOM event callbacks it is easy to mix up the context. Here is an example of how `bindAll` can be used to prevent unwanted context changes. Additionally, it makes use of the `functions` method in underscore to bind all user functions to the user context.
HTML:

{% highlight html %}

<div id="body">
    <input type="text" placeholder="Your Name Goes Here">
    <p>Hello, my name is: <span id="name"></span></p>
    <button>Who are you?</button>
</div>

{% endhighlight %}

JavaScript:
{% highlight javascript %}

var user = {
    name: "",
    onNameChange: function (event) {
	    this.name = event.target.value;
        this.updateView();
    },
    onButtonClick: function () {
        alert("Hello, my name is: " + this.name);
    },
    updateView: function () {
        $('span#name').text(this.name);
    }
};

// This binds all functions in user to the user context
_.bindAll.apply(_, [user].concat(_.functions(user)))

$('input').on('keyup', user.onNameChange);
$('button').on('click', user.onButtonClick);

{% endhighlight %}

[Here is a working example](http://jsfiddle.net/UJmGD/1028/)
