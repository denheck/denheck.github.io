---
layout: post
title:  "Component Views in Backbone"
date:   2015-03-27 16:36:00
categories: backbone
---

The new hotness in the javascript world seems to be frameworks which allow componentized views. This is great because it encourages DRY principles and enhances code reuse. It means that nasty customized autocomplete I had to build that one time will be pluggable into any view code I am currently working on. This works particularly well for frameworks that support it like React but what happens if you want to introduce this pattern to an existing project written in Backbone?

Since Backbone is pretty light on it's [view conventions](http://backbonejs.org/#View) finding the best way to add nested views or components can to your project can be tricky. A good start is to look at the many [community defined conventions](http://addyosmani.github.io/backbone-fundamentals/#working-with-nested-views). My personal favorite is modeled after the [Thorax](http://thoraxjs.org/) framework which is built on top of Backbone. It allows you to plug your views directly into a template using code like this:

{% highlight javascript %}

var parent = new Thorax.View({
    child: new Thorax.View(...),
    template: Handlebars.compile('{{view child}}')
});

{% endhighlight %}

The above example was taken from Addy Osmani's excellent book, [Backbone Fundamentals](http://addyosmani.github.io/backbone-fundamentals/#thorax). It shows an example of nesting a child view into its parent. The keywords "view child" found in the handlebars template will embed the child view while maintaining its event bindings.

I recently worked on a project where I wanted to use this feature but didn't need the additional features provided by Thorax or Handlebars. I wanted to do it in plain old Backbone with Underscore templates. Here is my version:

{% highlight javascript %}

var customTemplate = function (template) {
    var _template = _.template(template);
    var render = function (data, $el) {
        var children = [];

        data.view = function (child) {
            children[child.cid] = child;
            return "<div data-cid=" + child.cid + "></div>"
        }

        $el.html(_template(data));

        $el.find('[data-cid]').each(function () {
            var $child = $(this);
            var child = children[$child.data('cid')];
            $child.replaceWith(child.render().el);
            child.delegateEvents();
        });
    };

    return render;
};

var Parent = Backbone.View.extend({
    tagName: 'form',
    initialize: function (options) {
        this.child = options.child;
    },
    template: customTemplate(
        '<label>Panic Button: <%= view(child) %></label>'
    ),
    render: function () {
        var data = {
            child: this.child
        };

        this.template(data, this.$el);
        return this;
    },
    remove: function () {
        this.child.remove();
        Backbone.View.prototype.remove.apply(this);
    }
});

var Child = Backbone.View.extend({
    tagName: 'button',
    events: {
        "click": "clicked"
    },
    clicked: function(e){
        e.preventDefault();
        alert("I was clicked!");
    },
    render: function () {
        this.$el.html("Clicketh Thine Button");
        return this;
    }
});

$(function () {
    var parent = new Parent({
        child: new Child()
    });

    // render can be called multiple times without breaking event handling!
    parent.render();
    parent.render();
    parent.render();


    $('div#body').html(parent.render().$el);
});

{% endhighlight %}

I am using a customTemplate wrapper around the existing Underscore template to provide a helper function called "view". I simply pass the child view to the helper within the template like so `<%= view(child) %>`. Then in the parent's render function I call `this.template(data, this.$el)` which handles rendering the parent and all the nested children and sticking them in the DOM.

I like this solution because it doesn't require extending the existing Backbone.View or bringing in an outside custom templating library. It can also be plugged in seamlessly to any existing Backbone project. As an added bonus, rendering the parent is idempotent. That means I can call the render function as many times as I want without side effects.

[Here is a working interactive solution](http://jsfiddle.net/UJmGD/1016/)

Additional information on nested view handling:
[Backbone Fundamentals](http://addyosmani.github.io/backbone-fundamentals),
[Inspiration for custom template](https://lostechies.com/derickbailey/2012/04/26/view-helpers-for-underscore-templates/),
[Pragmatic Backbone Views](http://pragmatic-backbone.com/views)
