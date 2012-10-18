require 'rspec'
require_relative '../../lib/ataulfo'

describe Ataulfo::PatternMatching do

  it 'matches a single method' do
    passed_through_match = false
    object               = Struct.new(:a_method).new('something')

    with object do
      like a_method: some_var do
        expect(some_var).to eq('something')
        passed_through_match = true
      end
    end

    expect(passed_through_match).to be_true
  end

  it 'matches two methods' do
    passed_through_match = false
    object               = Struct.new(:method1, :method2).new('something', 'something else')

    with object do
      like method2: m2, method1: m1 do
        expect(m1).to eq('something')
        expect(m2).to eq('something else')
        passed_through_match = true
      end
    end

    expect(passed_through_match).to be_true
  end

  it 'two bodies, one execution' do
    passed_through_match = false
    object               = Struct.new(:a_method).new('something')

    with object do
      like this_does_not_exist: x do
        fail 'should not match a method that does not exist'
      end
      like a_method: x do
        expect(x).to eq('something')
        passed_through_match = true
      end
    end

    expect(passed_through_match).to be_true
  end

  it 'matches fixed values' do
    passed_through_match = false
    object               = Struct.new(:a_method).new('something')

    with object do
      like a_method: 'other_thing' do
        fail 'should not match a method with wrong value'
      end
      like a_method: 'something' do
        passed_through_match = true
      end
    end

    expect(passed_through_match).to be_true
  end

  it 'matches fixed values in variables' do
    passed_through_match = false
    object               = Struct.new(:a_method).new('something')
    fixed_value1 = 'other_thing'
    fixed_value2 = 'something'

    with object do
      like a_method: fixed_value1 do
        fail 'should not match a method with wrong value'
      end
      like a_method: fixed_value2 do
        passed_through_match = true
      end
    end

    expect(passed_through_match).to be_true
  end

  it 'matches fixed and var values mixed' do
    passed_through_match = false
    object               = Struct.new(:a_method, :another_method).new('something', 'other value')

    with object do
      like a_method: 'does not match', another_method: my_var do
        fail 'should not match a method with wrong value'
      end
      like a_method: 'something', another_method: my_var do
        expect(my_var).to eq('other value')
        passed_through_match = true
      end
    end

    expect(passed_through_match).to be_true
  end

  it 'matches nested objects'
  it 'matches hashes'
  it 'matches arrays'
end