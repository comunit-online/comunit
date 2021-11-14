FactoryBot.define do
  factory :author do
    user { nil }
    simple_image { nil }
    visible { false }
    surname { "MyString" }
    name { "MyString" }
    patronymic { "MyString" }
    title { "MyString" }
    about { "MyText" }
  end
end
