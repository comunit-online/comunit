FactoryBot.define do
  factory :post_link do
    uuid { "" }
    post { nil }
    other_post_id { 1 }
    priority { 1 }
    data { "" }
  end
end
