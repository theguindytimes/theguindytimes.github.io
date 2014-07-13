# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    title "MyString"
    from "2014-07-14 00:22:32"
    to "2014-07-14 00:22:32"
    timings "2014-07-14 00:22:32"
    description "MyText"
  end
end
