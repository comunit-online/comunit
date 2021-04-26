FactoryBot.define do
  factory :taxon do
    uuid { "" }
    simple_image { nil }
    parent_id { 1 }
    object_count { 1 }
    priority { 1 }
    visible { false }
    name { "MyString" }
    nav_text { "MyString" }
    slug { "MyString" }
    parents_cache { "MyString" }
    children_cache { 1 }
    data { "" }
  end
end
