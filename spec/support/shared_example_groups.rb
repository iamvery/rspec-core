shared_examples_for "metadata hash builder" do
  context "when RSpec.configuration.treat_symbols_as_metadata_keys_with_true_values is set to true" do
    let(:hash) { metadata_hash(:foo, :bar, :bazz => 23) }

    before(:each) do
      RSpec.configure { |c| c.treat_symbols_as_metadata_keys_with_true_values = true }
    end

    it 'treats symbols as metadata keys with a true value' do
      expect(hash[:foo]).to be(true)
      expect(hash[:bar]).to be(true)
    end

    it 'still processes hash values normally' do
      expect(hash[:bazz]).to be(23)
    end
  end

  context "when RSpec.configuration.treat_symbols_as_metadata_keys_with_true_values is set to false" do
    let(:warning_receiver) { RSpec }

    before(:each) do
      RSpec.configure { |c| c.treat_symbols_as_metadata_keys_with_true_values = false }
      warning_receiver.stub(:warn_with)
    end

    it 'prints a deprecation warning about any symbols given as arguments' do
      warning_receiver.should_receive(:warn_with).with(/In RSpec 3, these symbols will be treated as metadata keys/)
      metadata_hash(:foo, :bar, :key => 'value')
    end

    it 'does not treat symbols as metadata keys' do
      expect(metadata_hash(:foo, :bar, :key => 'value')).not_to include(:foo, :bar)
    end

    it 'does not print a warning if there are no symbol arguments' do
      warning_receiver.should_not_receive(:warn_with)
      metadata_hash(:foo => 23, :bar => 17)
    end
  end
end
