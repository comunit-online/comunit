require 'rails_helper'

RSpec.describe Agent, type: :model do
  subject { build :agent }

  specify { expect(subject).to be_valid }

  it_behaves_like 'requires_name'
  it_behaves_like 'has_unique_name'
  it_behaves_like 'limits_max_name_length', 255
  it_behaves_like 'strips_name'

  describe '::named' do
    it 'limits name length to 255 characters' do
      result = Agent.named('a' * 256)
      expect(result.name.length).to eq(255)
    end

    it 'does not duplicate existing agents' do
      subject.save!
      expect { Agent.named(subject.name) }.not_to change(Agent, :count)
    end

    it 'creates new agents' do
      expect { Agent.named(subject.name) }.to change(Agent, :count).by(1)
    end

    it 'returns instance of Agent' do
      expect(Agent.named('test')).to be_instance_of(Agent)
    end

    it 'substitutes "n/a" for blank name' do
      expect(Agent.named(' ').name).to eq('n/a')
    end
  end
end
