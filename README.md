# RestMyCase [![Code Climate](https://codeclimate.com/github/goncalvesjoao/rest_my_case/badges/gpa.svg)](https://codeclimate.com/github/goncalvesjoao/rest_my_case) [![Build Status](https://travis-ci.org/goncalvesjoao/rest_my_case.svg?branch=master)](https://travis-ci.org/goncalvesjoao/rest_my_case) [![Test Coverage](https://codeclimate.com/github/goncalvesjoao/rest_my_case/badges/coverage.svg)](https://codeclimate.com/github/goncalvesjoao/rest_my_case) [![Gem Version](https://badge.fury.io/rb/rest_my_case.svg)](http://badge.fury.io/rb/rest_my_case)

Light Ruby gem with everything you need in a "The Clean Architecture" use case scenario.

Many thanks to [@tdantas](https://github.com/tdantas) and [@junhanamaki](https://github.com/junhanamaki) and a shout-out to [@joaquimadraz](https://github.com/joaquimadraz) and his [compel](https://github.com/joaquimadraz/compel) ruby validations gem.

---

## 1) Installation

Add this line to your application's Gemfile:

    gem 'rest_my_case'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rest_my_case

---

## 2) Ideology
Your business logic goes into separated use cases...
```ruby
class FindPost < RestMyCase::Base

  def perform
    context.post = Post.find(context.id)
  end

end

class ArchivePost < RestMyCase::Base

  depends FindPost

  def perform
    context.post.status = 'archived'

    context.result = context.post.save
  end

end
```

web framework should only act as a bridge between the user and your business logic.
```ruby
class PostsController < ApplicationController

  def archive
    @context = ArchivePost.perform id: params[:id]

    if @context.result
      redirect_to @context.post
    else
      render "archive" #view post.errors
    end
  end

end
```

Ideally your business logic should be a ruby gem that can be tested independently from your framework.

Checkout this step by step tutorial: (WIP) on how to isolate your code into a ruby gem and connect it to your rails or sinatra api.

---

## 3) Basic usage

```ruby
class BuildPost < RestMyCase::Base
  def perform
    puts context.id
    puts context.post_attributes
  end
end
```

```
irb> params = { id: 1, post: { title: 'my first post' } }
irb> context = BuildPost.perform id: params[:id], post_attributes: params[:post]
1
{:title=>"my first post"}
irb> context.id
1
```

The Hash passed down to **BuildPost.perform** will be available through an instance method called **#context** that will return an OpenStruct object initialized with that Hash (see more in section 7).

Executing **BuildPost.perform** will instantiate your use case and all of its **dependencies**, build a **context** with the contents of **params**, run your use case (and its dependencies) with that context and return it at the end.

## 1.1) Normal usage
Organize your use cases by single responsibilities and establish your use case flow through "dependencies".

```ruby
class FindPost < RestMyCase::Base
  def perform
    context.post = Post.find(context.id)
  end
end

class BuildPost < RestMyCase::Base
  depends FindPost

  def perform
    context.post.assign_attributes context.post_attributes

    puts post.name
  end
end
```
- The class method **.depends** will make **BuildPost** dependent of **FindPost** which means that calling **BuildPost.perform** will run **FindPost.perform** first. Both use cases will share the same context.

```
irb> params = { id: 1, post: { title: 'my first post' } }
irb> BuildPost.perform id: params[:id], post_attributes: params[:post]
"my first post"
```

---

## 4) Lifecycle

## 4.1) Waiting to be implemented methods
Methods: **#setup**, **#perform**, **#rollback** and **#final**
```ruby
class UseCase1 < RestMyCase::Base
  def setup
    puts 'UseCase1#setup'
  end
  def perform
    puts 'UseCase1#perform'
    error if context.should_fail
  end
  def rollback
    puts 'UseCase1#rollback'
  end
  def final
    puts 'UseCase1#final'
  end
end
```

```
irb> UseCase1.perform #will print
"UseCase1#setup"
"UseCase1#perform"
"UseCase1#final"
```

Method **#rollback** will be called after each **#perform** in the reverse order if **#error** is invoked inside a **#setup** of **#perform** (see more in section 5).
```
irb> UseCase1.perform(should_fail: true) #will print
"UseCase1#setup"
"UseCase1#perform"
"UseCase1#rollback"
"UseCase1#final"
```

Method **#final** will run last and always, no matter how many times **#error** was called.

---

### 4.2) Dependencies
Default behaviour is to run your dependencies (**#setup**, **#perform**, **#rollback** and **#final**) methods, first.
```ruby
class UseCase2 < RestMyCase::Base
  def perform
    puts 'UseCase2#perform'
  end
end

class UseCase3 < RestMyCase::Base
  def perform
    puts 'UseCase3#perform'
  end
end

class UseCase1 < RestMyCase::Base
  depends UseCase2,
          UseCase3

  def perform
    puts 'UseCase1#perform'
  end
end
```

```
irb> UseCase1.perform #will print
"UseCase2#perform"
"UseCase3#perform"
"UseCase1#perform"
```

See section 8 for more examples.

---

## 5) Flow control methods

Methods | Behaviour
------- | ---------
**#abort** | Stops other remaining use cases from running and triggers **#rollback** on already executed use cases (in reverse order).
**#skip** | Will prevent **#perform** (of the use case that called **#skip**) from running and will not stop other use cases from running nor trigger a **#rollback** (only works by being used inside a **#setup** method).
**#error(error_message = '')** | Will do the same as **#abort** but will also push **error_message** to **#context.errors** array so you can track down what happen in what use case (see more in section 7).
**#invoke(*use_case_classes)** | Does the same as the class method **.depends** but executes the use cases on demand. Shares the context to them and if they call **#abort** on their side, the use case that **invoked** will also **abort**.

**#skip**, **#abort**, **#error** and **#invoke** have a "bang!" version that will raise a controlled exception, preventing the remaining lines of code from running.
```ruby
class UseCase1 < RestMyCase::Base
  def perform
    puts 'before #error!'
    error!
    puts 'after #error!'
  end
end
```

```
irb> UseCase1.perform #will print only
"before #error!"
```

---

## 6) Configuration methods

Methods | Behaviour
------- | ---------
**.depends(*use_case_classes)** | Adds the **use_case_classes** array to the use case's **dependencies** list, that will be executed by order before the actual use case (see more in section 4).
**.context_reader(*methods)** | Defines getter methods that return **context.send method**, to help reduce the **context.method** boilerplate.
**.context_writer(*methods)** | Defines setter methods that set **context.send "#{method}=", value**, to help reduce the **context.method = value** boilerplate.
**.context_accessor(*methods)** | Calls both **.context_reader** and **.context_writer** methods.
**.silence_dependencies_abort=** | If **false** once a dependency calls **#abort(!)** the next in line dependencies will not be called (and **#rollback** will be called in reverse order) but if **true** all dependencies will run no matter how many times **#abort(!)** was called (usefull when you want to run multiple validations, (see more in section 9).

---

## 7) **#context** methods
The returning object is an instance of **RestMyCase::Context::Base** class that inherits from **OpenStruct** and implements the following methods:

Methods | Behaviour
------- | ---------
**#attributes** | Alias to **#marshal_dump**, returns all of the context's stored data.
**#to_hash** | Serializes and unserializes **#attributes** turning any existing ruby objects into serialized strings.
**#valid?** | Checks if **#errors** is empty
**#ok?** | Alias to **#valid?**
**#success?** | Alias to **#ok?**
**#errors** | Array that gets 'pushed' with **{ message: error_message, class_name: <UseCaseClass> }** (or **error_message** itself if **error_message** already a Hash) every time **<UseCaseClass>#error(error_message)** is called.

If **defined?(ActiveModel)** is true, **ActiveModel::Serialization** will be included and in turn methods like **#to_json(options = {})** and **#serializable_hash(options = nil)** will become available.

---

### 8) Examples
If **UseCase1** depends on **UseCase2** and **UseCase3** in that respective order.
Running **UseCase1.perform** will pass down the context to each use case in the following manner:

#### 8.1) Given that no use case called the method **#error**
```
UseCase2#setup -> UseCase3#setup -> UseCase1#setup ->
UseCase2#perform -> UseCase3#perform -> UseCase1#perform ->
UseCase2#final -> UseCase3#final -> UseCase1#final
```

#### 8.2) Given that **UseCase3#setup** calls **#skip(!)**
```
UseCase2#setup -> UseCase3#setup -> UseCase1#setup ->
UseCase2#perform -> UseCase1#perform ->
UseCase2#final -> UseCase3#final -> UseCase1#final
```

#### 8.3) Given that **UseCase3#setup** calls **#error(!)**
```
UseCase2#setup -> UseCase3#setup ->
UseCase3#rollback -> UseCase2#rollback ->
UseCase2#final -> UseCase3#final -> UseCase1#final
```

#### 8.4) Given that **UseCase3#perform** calls **#error(!)**
```
UseCase2#setup -> UseCase3#setup -> UseCase1#setup ->
UseCase2#perform -> UseCase3#perform ->
UseCase3#rollback -> UseCase2#rollback ->
UseCase2#final -> UseCase3#final -> UseCase1#final
```

---

## 9) RestMyCase::Validator class
- This class is going to suffer some massive changes as I'm thinking delegating all of the validation responsibilities to [compel](https://github.com/joaquimadraz/compel) gem.

---

## 10) RestMyCase::Status module
Implements following methods:

Methods | Behaviour
------- | ---------
**#context** | Returns an instance of **RestMyCase::Context::Status**
**#status** | Returns **context.status** (see more in section 10.1)
**#failure(status, error_message = nil)** | WIP

**#failure!** is also present and does the same as the other flow control "bang!" methods (see section 5).

### 10.1) RestMyCase::Context::Status
WIP

---

## 11) RestMyCase::HttpStatus module (for seamless API integration)
Includes the module **RestMyCase::Status** and **#context** becomes an instance of **RestMyCase::Context::HttpStatus**.

### 11.1) RestMyCase::Context::HttpStatus
WIP
