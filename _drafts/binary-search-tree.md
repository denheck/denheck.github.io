---
layout: post
title:  "Binary Search Trees"
date:   2015-03-18 21:35:12
categories: algorithms
---

Binary Search Tree

A binary search tree is an algorithm used to quickly lookup, insert and delete values.
It works by dividing the number of values to search for in half with each
recursive search iteration.
A real world example of what is happening might look like this:
Say I have an unsorted array containing the 10 numbers. If I want to find out if 3 is in the array,
I would have to search through each number in a linear fashion in order to find that it.
Something like this:

{% highlight javascript %}

var ten = [1,2,3,4,5,6,7,8,9,10];

function search(find, arr) {
  arr.forEach(function (number) {
    if (number === find) return true;
  });

  return false;
}

search(3, ten);

{% endhighlight %}

Best case scenario the number 3 ends up being the first item in the array. Worst case scenario
3 is the last number in the array or doesn't exist at all.
To more efficiently test for the existence of the number 3 we can store our 10 numbers
in a data structure optimized for searching. A Binary Search Tree will do nicely.

{% highlight javascript %}

var Node = function (data) {
  this.data = data;
  this.left = null;
  this.right = null;
};

Node.prototype.insert = function (data) {
  if (data <= this.data) {
    if (this.left) {
      this.left.insert(data);
    } else {
      this.left = new Node(data);
    }
  } else if (data > this.data) {
    if (this.right) {
      this.right.insert(data);
    } else {
      this.right = new Node(data);
    }
  }
};

Node.prototype.lookup = function (data) {
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


To explain how this is faster and more efficient I will go back to the example of searching for the number 3. Assuming the tree is balanced, you can find out if the number 3 exists in the tree in a maximum of 4 checks. This is true even if 3 doesn't exist in the structure. To show the example I will use the following function to build my tree from the numbers.

{% highlight ruby %}

Node.build = function () {
  // This function is variadic, meaning it doesn't have a predefined arity.
  // It will use javascripts "arguments" object, which exists within the scope
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

var tree = Node.build(5, 3, 23, 2, 4, 19, 24, 1, 24, 26);
tree.lookup(3); // true

{% endhighlight %}

Now for the explanation. The tree consists of a root node containing a number at the top with two nodes underneath, one on the left the other on the right. The node on the left represents values less than or equal to the root node. The node on the right contains values greater than the root node. Additionally, each of the nodes underneath is also a root node. This means they have two nodes underneath representing values less than or equal to and values greater than respectively.

 This makes searching through the tree as simple as determining how the value you are looking for compares to the root node. In our case, 5 is at the top of the tree and is the highest root node.

The issue with our current build function is that it doesn't optimize the tree. It prioritizes insertion speed over speed of lookup (check this!!). This means if you pass Node.build(1,2,3,4) your lookups will be linear. They won't be optimized with all the binary tree lookup speed goodness.

http://stackoverflow.com/questions/2130416/what-are-the-applications-of-binary-trees
http://algs4.cs.princeton.edu/32bst/
http://en.wikipedia.org/wiki/Self-balancing_binary_search_tree
http://en.wikipedia.org/wiki/Binary_search_tree
http://cslibrary.stanford.edu/110/BinaryTrees.html