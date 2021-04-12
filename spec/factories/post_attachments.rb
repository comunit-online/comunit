FactoryBot.define do
  factory :post_attachment do
    uuid { "" }
    post { nil }
    name { "MyString" }
    attachment { "MyString" }
    data { "" }
  end
end
