---
layout: post
title:  "PHP Recursing Anonymous Functions"
date:   2015-11-29 20:30:00
categories: php languages
---

In PHP, recursively calling an anonymous function usually involves first binding it to a variable and passing the function to itself via the "use" language construct. "use" allows anonymous functions to inherit variables from the parent scope. So if you wanted to compute the fibonacci number for 5 recursively using an anonymous function you would have to do the following:

{% highlight php %}

$fib = function ($n) use (&$fib) {
    return $n > 1 ? $fib($n - 1) + $fib($n - 2) : $n;
};

{% endhighlight %}

Note: you must pass a reference of the $fib variable in order for this to work.

This isn't particularly difficult but what if you didn't want to bind the function to a variable. Maybe you don't want to pollute the parent scope with a variable declaration that will be otherwise unused. You could always define the function the traditional way like so:

{% highlight php %}

function fib($n) {
    return $n > 1 ? fib($n - 1) + fib($n - 2) : $n;
}

{% endhighlight %}

That's certainly easier. The tradeoff being it is no longer anonymous and has to be given a name and defined. Okay, so let's say you want an anonymous unbound function to call itself in PHP. It's hard to imagine any way to do this.

Turns out a really smart guy named Haskell, the same guy the purely functional was named after, invented a way to accomplish just this. It's called the Y Combinator. Also, for disambiguation purposes I am not talking about the venture capital firm.

The Y Combinator allows a function to recursively call itself without needing to bind it to a variable or define it. I won't go into detail about the Y Combinator and how it works in this blog post but if you are interested, here is a Lambda Calculus [crash course](https://medium.com/@ayanonagon/the-y-combinator-no-not-that-one-7268d8d9c46#.wunhp47i6). For our purposes it is good enough to know that this is possible. It's actually not even that difficult to implement in PHP.

To start, I need to create a function that recursively calls other functions and passes arguments to them. Something like the following:

{% highlight php %}

function recurse($func, $n) {
    return $func($func, $n);
};

{% endhighlight %}

 Then I can pass it the fibonacci function as a parameter along with the desired number to compute:

{% highlight php %}

$fibNumber = recurse(function ($self, $n) {
    return $n > 1 ? $self($self, $n - 1) + $self($self, $n - 2) : $n;
}, 6);

{% endhighlight %}

I had to make a modification to the fibonacci function. Instead of just passing $n - 1 and $n - 2 to itself, I also included the fibonacci function as the first parameter. This allows the recursion to continue as you can see the fibonacci function signature requires the first parameter to be itself.

This is a good start but what if I need to pass multiple parameters to the recursing function? What if I want to reuse the recurse function for other anonymous functions? Again, this is really easy in PHP 5.6 with the addition of variadic functions and argument unpacking. I just need to change the function signature of recurse to accept any number of parameters and forward them to the recursive function like so:

{% highlight php %}

function recurse($func, ...$args) {
    return $func($func, ...$args);
}

{% endhighlight %}

Note: if you aren't familiar variadic functions and argument unpacking in PHP 5.6 check it out [here](http://php.net/manual/en/migration56.new-features.php)
