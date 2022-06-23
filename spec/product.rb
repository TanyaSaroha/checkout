FactoryGirl.define do
  factory :product, class: OpenStruct do
    trait :product1 do
      id 1
      code '001'
      name 'Silver Earrings'
      price 9.25
    end
    trait :product2 do
      id 2
      code '002'
      name 'Dove Dress in Bamboo'
      price 45.00
    end
    trait :product3 do
      id 3
      code '003'
      name 'Autumn Floral Shirt'
      price 19.95
    end
  end
end
