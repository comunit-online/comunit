FactoryBot.define do
  factory :site do
    uuid { "" }
    simple_image { nil }
    active { false }
    version { 1 }
    name { "MyString" }
    host { "MyString" }
    token { "MyString" }
    data { "" }
    local { false }
  end
end
