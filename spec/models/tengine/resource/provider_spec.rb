require 'spec_helper'

describe Tengine::Resource::Provider do

  valid_attributes1 = {
    :name => "provider1"
  }

  describe :validation do
    context "valid" do
      subject{ Tengine::Resource::Provider.new(valid_attributes1) }
      its(:valid?){ should be_true }
    end

    context "invalid" do
      subject{ Tengine::Resource::Provider.new }
      its(:valid?){ should be_false }
    end
  end

end
