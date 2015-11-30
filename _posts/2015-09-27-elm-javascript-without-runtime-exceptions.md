---
layout: post
title:  "Elm: Javascript Without Runtime Exceptions"
date:   2015-09-27 12:30:00
categories: javascript languages elm
---

Have you ever wondered what JavaScript programming would be like without runtime exceptions. Never accidentally calling a method on a non-object or the wrong object. Not getting stuck with null or undefined when you least expect it. If you are programming in Elm this is your reality. Elm users don't have to worry about runtime exceptions because Elm doesn't have them.

### Really, No Runtime Exceptions

That's correct! The only way to get a runtime exception in Elm is to invoke it yourself using the crash method in the Debug library:

{% highlight javascript %}

import Html exposing (text)  
import Debug exposing (crash)

type Animal = Cat | Dog | Spoon

speak : Animal -> String
speak animal =
  case animal of
    Cat -> "Meow"
    Dog -> "Bark"
    Spoon -> crash("Spoons aren't animals!")

main = text (speak Spoon)

{% endhighlight %}

Other strongly typed languages have similar runtime guarantees but the thing that makes Elm standout is that it is actually just JavaScript.

Elm compiles directly to a JavaScript file similar to CoffeeScript and TypeScript. So that means you can create applications in the JavaScript ecosystem without runtime exceptions.

### Why this is a big deal

In a dynamic language that is weakly typed like JavaScript, it is difficult to guarantee that all code paths are safe from runtime errors. Even with 100% code covering tests it is still likely that a parameter could get passed around with an unexpected or unknown type. This leads to runtime exceptions which will probably come up when you least expect it and probably in production.

Javascript runtime exception example:

{% highlight javascript %}

function Str(a) {
  return a.toString();
}

var nums = [1,2,3,4];

console.log(nums.map(Int)); // ["1","2","3","4"]

nums.push(null)

console.log(nums.map(Int)); // TypeError: a is null

{% endhighlight %}

Elm avoids these problems because the compiler requires your types to be predefined before runtime. The compiler will complain if a situation is encountered where a runtime exception could occur. What's that you say? Type declarations are verbose and you don't want them to ruin your concise JS code. Good news, you don't have to.

Elm is a statically typed language but it also has type inference. That means if you want to omit type declarations from your code you can do so and the compiler will automatically derive the types for you. If the correct type cannot be derived because of ambiguous inputs the compiler will inform you and you can simply correct the program. Below is an example of an Elm script that uses type inference followed by one that doesn't.

{% highlight javascript %}

{-- type declaration --}

import Html exposing (text)  

type alias Book = { title: String, cost: Float }

create : String -> Float -> Book
create title cost =
  { title = title, cost = cost }

book = create "Elm for JavaScripters" 15.99
main = text book.title


{-- no type declaration --}

import Html exposing (text)  

create title cost =
  { title = title, cost = cost }

book = create "Elm for JavaScripters" 15.99
main = text book.title

{% endhighlight %}

As you can see, if types are really cramping your style you can ditch them and the compiler will figure out what you want.

If you haven't checked out Elm before you should definitely give it a try. It is changing the way I think about front-end web development. Not worrying about runtime applications is just one of the many cool features Elm offers.
