require 'rails_helper'

RSpec.describe Trip, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_inclusion_of(:rating).in_range(1..5) }
end
