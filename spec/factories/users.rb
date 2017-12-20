FactoryBot.define do
  factory :user do
    first_name "Joe"
    last_name "Doe"
    email "joedoe@sample.com"
    password "password"
    organization nil
  end
end
