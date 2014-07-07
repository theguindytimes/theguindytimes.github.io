# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    name "MyString"
    email "MyString"
    subject "MyString"
    body "MyText"
  end
end
