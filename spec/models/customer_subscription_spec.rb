require 'rails_helper'

RSpec.describe CustomerSubscription, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should belong_to :subscription }
  end

  describe 'Enums' do
    it 'enums tests' do
      should define_enum_for(:status).with_values(["active", "cancelled"])
    end
  end

  describe 'instance methods' do
  end
end