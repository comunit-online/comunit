class Agent < ApplicationRecord
  include RequiredUniqueName

  NAME_LIMIT = 255

  validates_length_of :name, maximum: NAME_LIMIT

  # @param [String] name
  def self.named(name)
    name = 'n/a' if name.blank?

    find_or_create_by(name: name.to_s[0..254])
  end
end
