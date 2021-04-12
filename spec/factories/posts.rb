FactoryBot.define do
  factory :post do
    uuid { "" }
    user { nil }
    agent { nil }
    ip_address { nil }
    visible { false }
    featured { false }
    video { false }
    rating { 1.5 }
    view_count { 1 }
    publication_time { "2021-04-12 09:24:06" }
    title { "MyString" }
    slug { "MyString" }
    source_name { "MyString" }
    source_link { "MyString" }
    lead { "MyText" }
    body { "MyText" }
  end
end
