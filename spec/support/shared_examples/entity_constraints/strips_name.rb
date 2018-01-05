require 'rails_helper'

RSpec.shared_examples_for 'strips_name' do
  describe 'before validation' do
    it 'strips name' do
      expected     = subject.name.to_s
      subject.name = " #{expected} "
      subject.valid?
      expect(subject.name).to eq(expected)
    end
  end
end
