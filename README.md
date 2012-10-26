# Ataulfo

A DSL for **pattern matching** over object in Ruby.

What does it do? It's a conditional clause based on the object interface. It also allows you do make "multi-assignment".

Example:

    object = Struct.new(:method1, :method2).new
    object.method1 = 'something'
    object.method2 = 'something else'

    with object do
      like method1: m1, method2: m2 do
        puts m1 # 'something'
        puts m2 # 'something else'
      end
    end

Another example:

    object = Struct.new(:a_method).new
    object.a_method = 'something'

    with object do
      like this_method_does_not_exist: x do
        fail 'it will not reach here'
      end
      like a_method: x do
        puts x # 'something'
      end
    end

## Installation

Add this line to your application's Gemfile:

    gem 'ataulfo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ataulfo

## Contributing

If you want to play around, clone the project, run the specs and have fun.

Since this is really tiny and more a "Proof of Concept" than something I would use in production code, I'm not planning
to actively work on it. But if you need some help, send me an e-mail: ronie.uliana at gmail. I'll be happy to help you.

## Licensing

(MIT License)

Copyright (c) 2012 Ronie Uliana

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.