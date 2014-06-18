# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    user_id "MyString"
    article_id "MyString"
    value 1
  end
end
