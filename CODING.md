Coding style guideline
======================

Intro
-----
This guideline was created with the goal to keep the coding style consistent throughout the codebase. At its current state its **work in progress** and currently **nothing is to be considered final**.

**Important note:** Please avoid full file tidying as this creates a huge diff that may be a PITA to review. Especially not, when you're changing other things not related to code tidying and/or aren't 100% sure about what you're doing.

That said, let's start with the guideline.

Curly braces
------------
### Packages, classes and functions
Put the open curly brace into a new line:

```as3
package foo.bar.moo
{
	class FooBar extends Foo
	{
		public function foo(moo:int):void
		{
			// ...
		}

		public function bar():void
		{
			// ...
		}
	}
}
```

In addition to that use an empty line between function definitions like in the example above.

### Control structures (if/else if/else/while/for/switch/...)
Put the opening curly brace into **the same** line:

```as3
if (foobar == "moo") {
	expression;
	expression;
} else {
	expression;
	expression;
	expression;
	expression;
}

switch (foobar) {
	case "moo":
		//do this
		break;

	case "quack":
		//do that
		break;

	default:
		// do something else
}
```
If **both** the `if (expr)` and the `else`-branch contain a single expression you may omit the curly braces. But not, if at least one of them contains multiple expressions. The expressions should go into a new line. Not into the same line:

##### Do this
```as3

if (foo == "bar")
	outputText("foobar");
else
	outputText("moo");

if (foobar == "moo") {
	outputText("blah, blah");
} else {
	outputText("blah, blah");
	outputText("yadda, yadda");
}
```

##### But dont't do this:
```as3
if (foo == "bar")
	outputText("foobar");
else outputText("moo");

if (foobar == "moo")
	outputText("blah, blah");
else {
	outputText("blah, blah");
	outputText("yadda, yadda");
}
```

#### Good practice for the `else` in conditionals
Try keeping the `else`-part of a conditional as near as possible to the `if`

##### Avoid this:
```as3
if (foobar == "moo") {
	expression;
	expression;
	expression;
	expression;
	expression;
} else {
	expression;
}
```

##### Instead use this:
```as3
if (foobar != "moo") {
	expression;
} else {
	expression;
	expression;
	expression;
	expression;
	expression;
}
```

As you can see there, I've changed the condition to the opposite. From `foobar == "moo"` to `foobar != "moo"` in that case.

### Indenting and aligning code
Indent with single tabs (per indentation level) and align with spaces:
![Screenshot of aligned and indented code](https://user-images.githubusercontent.com/13157984/35690557-74b48ada-0776-11e8-860d-1e8a6787f7e6.png "Screenshot of aligned and indented code")

### Avoid extremely long lines of code
While mode IDEs and editors may have word wrapping, GitHub hasn't and not everyone likes word-wrapping. Look at the screenshot above how extremely long lines of code could be wrapped.
Many editors allow setting up a vertical line to assist you with that task. In FlashDevelop for example the settting for this is called 'Print Margin Column'. I have set mine to 150.
