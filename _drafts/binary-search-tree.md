---
layout: post
title:  "Binary Search Trees"
date:   2015-03-18 21:35:12
categories: algorithms data-structures
---

A binary search tree is a recursive data structure useful for storing data in a quickly retrievable manner. It finds a stored value by bisecting the number of values contained in the tree with each recursive search iteration until a single value is left. Storing data in this manner is much more efficient than using a basic unsorted array. In this article, I will briefly show examples of a binary search tree in javascript and compare it to an unsorted array.

Say I have an unsorted array containing 10 numbers. If I want to find out if 3 is in the array, I would have to search through each number linearly. Something like this:

{% highlight javascript %}

var ten = [1,2,3,4,5,6,7,8,9,10];

function search(find, arr) {
  for (var number of arr) {
    if (number === find) return true;
  }

  return false;
}

search(3, ten);

{% endhighlight %}

Best case scenario 3 ends up being the first item in the array. Worst case scenario it is last or doesn't exist at all. To more efficiently test for the existence of 3 we can store our 10 numbers in a data structure optimized for fast searching. A Binary Search Tree will do nicely:

{% highlight javascript %}

var Tree = function (data) {
  this.data = data;
  this.left = null;
  this.right = null;
};

Tree.prototype.insert = function (data) {
  if (data <= this.data) {
    if (this.left) {
      this.left.insert(data);
    } else {
      this.left = new Tree(data);
    }
  } else if (data > this.data) {
    if (this.right) {
      this.right.insert(data);
    } else {
      this.right = new Tree(data);
    }
  }
};

Tree.prototype.lookup = function (data) {
  if (this.data == data) {
    return this.data;
  }

  if (data < this.data && this.left) {
    return this.left.lookup(data);
  } else if (data > this.data && this.right) {
    return this.right.lookup(data);
  } else {
    return null;
  }
};

{% endhighlight %}

The code above describes a basic tree structure with a lookup and insert method. Before adding ten numbers and searching, I will describe how a simplified version of the tree works.

First, I create a tree using the new operator passing it the data value 2.

{% highlight javascript %}

var tree = new Tree(2);

{% endhighlight %}

Now I will add two more data values to the tree.

Upon inserting the value 1 into the tree it will compare 1 to it's existing value, in this case 2, and decide if it should create another tree on it's left or right property. If the value is less than or equal to the tree's existing value it will create a new tree on the left containing the inserted value. If it is greater than the tree's existing value it will create a new tree on the right containing the inserted value.

The code below will create a tree with 1 on the left property of the tree calling the method and a tree with 3 on the right property of the tree calling the method.

{% highlight javascript %}

tree.insert(1);
tree.insert(3);

{% endhighlight %}

The tree will end up looking like the following object literal:

{% highlight javascript %}

var tree = {
  data: 2,
  left: {
    data: 1,
    left: null,
    right: null
  },
  right: {
    data: 3,
    left: null,
    right: null
  }
};

{% endhighlight %}

This may not seem like much but as the amount of data stored in the tree increases it becomes more useful. Now I am going to create a tree building function to demonstrate how much faster we can find the number 3 in a group of 10 numbers.

{% highlight javascript %}

Tree.build = function () {
  // This function is variadic, meaning it doesn't have a predefined arity.
  // It will use javascript's "arguments" object, which exists within the scope
  // of each function when it is called. The following method converts that object
  // into an array.
  var nodeData = [].slice.call(arguments, 0, arguments.length);
  var tree;

  nodeData.forEach(function (data) {
    if (!tree) {
      tree = new Node(data);
    } else {
      tree.insert(data);
    }
  });

  return tree;
};

{% endhighlight %}

Now I will create the tree and search for the number 3.

{% highlight javascript %}

var tree = Node.build(5, -10, 23, -15, 3, -18, 19, 24, 24, 26);
tree.lookup(3); // true

{% endhighlight %}

I can find out if the number 3 exists in the tree in a maximum of 4 checks now.

How does it work? Starting with the number 5 it determines that 3 is less than 5. The structure then knows it only needs to check the values in the structure less than 5, i.e. -10, 3, -15 and -18. Then coming to -10 it determines that 3 is greater than -10 so it is looking for a value less than 5 but greater than -10. The only value in the structure meeting that criteria is 3. So it returns the value 3.

One issue with the build function is that it doesn't optimize the tree. This means if you pass Node.build(1,2,3,4) your lookups will be linear and take just as much time as the unsorted array we talked about earlier. For the best search performance a binary tree needs to be self-balancing.

http://stackoverflow.com/questions/2130416/what-are-the-applications-of-binary-trees
http://algs4.cs.princeton.edu/32bst/
http://en.wikipedia.org/wiki/Self-balancing_binary_search_tree
http://en.wikipedia.org/wiki/Binary_search_tree
http://cslibrary.stanford.edu/110/BinaryTrees.html