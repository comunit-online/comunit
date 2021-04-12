FactoryBot.define do
  factory :post_note do
    uuid { "" }
    post { nil }
    priority { 1 }
    body { "MyText" }
    data { "" }
  end
end
