require 'spec_helper'
require_relative '../src/checkout'
require_relative './factories/product'

describe Checkout do
  context 'test 2 or more earrings promotion' do
    it 'does not apply discount if only one earring is bought' do
      product1 = FactoryGirl.build(:product, :product1)
      subject.scan product1

      total = subject.total
      expect(total).to eq(9.25)
    end

    it 'should apply discount if 2 earrings are bought' do
      product1 = FactoryGirl.build(:product, :product1)
      subject.scan product1
      subject.scan product1

      total = subject.total
      expect(total).to eq(17.0)
    end

    it 'should apply discount if 3 earrings are bought' do
      product1 = FactoryGirl.build(:product, :product1)
      subject.scan product1
      subject.scan product1
      subject.scan product1

      total = subject.total
      expect(total).to eq(24.75)
    end

    # Basket: 001,003,001
    # Total price expected: £36.95
    it 'should apply discount if products are bought in any order' do
      product1 = FactoryGirl.build(:product, :product1)
      product3 = FactoryGirl.build(:product, :product3)
      subject.scan product1
      subject.scan product3
      subject.scan product1

      total = subject.total
      expect(total).to eq(36.95)
    end

  end

  context 'total bill promotion' do
    # Basket: 001,002
    it 'should not apply discount on the total if less than min_amount' do
      product1 = FactoryGirl.build(:product, :product1)
      product2 = FactoryGirl.build(:product, :product2)

      subject.scan product1
      subject.scan product2

      total = subject.total
      expect(total).to eq(54.25)
    end

    # Basket: 001,002,003
    # Total price expected: £66.78
    it 'should apply discount on the total if more than min_amount' do
      product1 = FactoryGirl.build(:product, :product1)
      product2 = FactoryGirl.build(:product, :product2)
      product3 = FactoryGirl.build(:product, :product3)

      subject.scan product1
      subject.scan product2
      subject.scan product3

      total = subject.total
      expect(total).to eq(66.78)
    end
  end

  #Basket: 001,002,001,003
  # Total price expected: £73.76
  it 'combines discount on total and items' do
    product1 = FactoryGirl.build(:product, :product1)
    product2 = FactoryGirl.build(:product, :product2)
    product3 = FactoryGirl.build(:product, :product3)
  
    subject.scan product1
    subject.scan product2
    subject.scan product1
    subject.scan product3

    total = subject.total
    expect(total).to eq(73.76)
  end

  it 'does not apply discount on the product if not meant to' do
    product3 = FactoryGirl.build(:product, :product3)
    subject.scan product3
    subject.scan product3
  
    total = subject.total
    expect(total).to eq(39.90)
  end

end
