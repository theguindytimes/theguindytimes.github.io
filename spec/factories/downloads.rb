# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :download do
    title "MyString"
    category "MyString"
    description "MyText"
    edition "2014-07-14"
  end
end
