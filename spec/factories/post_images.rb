FactoryBot.define do
  factory :post_image do
    uuid { "" }
    post { nil }
    simple_image { nil }
    priority { 1 }
    visible { false }
    description { "MyText" }
    data { "" }
  end
end
