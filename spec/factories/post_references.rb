FactoryBot.define do
  factory :post_reference do
    uuid { "" }
    post { nil }
    priority { 1 }
    authors { "MyString" }
    title { "MyString" }
    url { "MyString" }
    publishing_info { "MyString" }
    data { "" }
  end
end
