# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    user_name "MyString"
    body "MyText"
    article_id 1
  end
end
