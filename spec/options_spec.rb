describe Fastlane::Actions::VersionIconAction do
  let(:action) { Fastlane::Actions::VersionIconAction }
  let(:configuration) { FastlaneCore::Configuration }

  context 'when passing the appiconset path' do
    it 'sets the value when it is valid' do
      options = { appiconset_path: './spec/fixtures/Correct.appiconset' }

      config = configuration.create(action.available_options, options)

      expect(config[:appiconset_path]).to eq(options[:appiconset_path])
    end

    it 'raises an exception when it isn\'t found' do
      options = { appiconset_path: './spec/fixtures/Missing' }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Appiconset not found')
    end

    it 'raises an exception when it isn\'t a directory' do
      options = { appiconset_path: './spec/fixtures/File.appiconset' }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Appiconset is not a directory')
    end

    it 'raises an exception when it isn\'t named correctly' do
      options = { appiconset_path: './spec/fixtures/Name.incorrect' }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Appiconset does not end with .appiconset')
    end
  end

  context 'when passing the text margins percentages' do
    it 'sets the value when it is 1' do
      options = { text_margins_percentages: [0.1] }

      config = configuration.create(action.available_options, options)

      expect(config[:text_margins_percentages]).to eq(options[:text_margins_percentages])
    end

    it 'sets the value when they are 2' do
      options = { text_margins_percentages: [0.1, 0.2] }

      config = configuration.create(action.available_options, options)

      expect(config[:text_margins_percentages]).to eq(options[:text_margins_percentages])
    end

    it 'sets the value when they are 4' do
      options = { text_margins_percentages: [0.1, 0.2, 0.3, 0.4] }

      config = configuration.create(action.available_options, options)

      expect(config[:text_margins_percentages]).to eq(options[:text_margins_percentages])
    end

    it 'raises an exception when they are less than 1' do
      options = { text_margins_percentages: [] }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('The number of margins is not equal to 1, 2 or 4')
    end

    it 'raises an exception when they are greater than 4' do
      options = { text_margins_percentages: [0.1, 0.2, 0.3, 0.4, 0.5] }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('The number of margins is not equal to 1, 2 or 4')
    end

    it 'raises an exception when any of them is less than 0' do
      options = { text_margins_percentages: [0.1, -1.2] }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('At least one margin percentage is less than 0')
    end

    it 'raises an exception when any of them is greater than 1' do
      options = { text_margins_percentages: [0.1, 0.2, 1.3, 0.4] }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('At least one margin percentage is greater than 1')
    end
  end

  context 'when passing the band height percentage' do
    it 'sets the value when it is valid' do
      options = { band_height_percentage: 0.42 }

      config = configuration.create(action.available_options, options)

      expect(config[:band_height_percentage]).to eq(options[:band_height_percentage])
    end

    it 'raises an exception when it is less than 0' do
      options = { band_height_percentage: -1.3 }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Band height percentage is less than 0')
    end

    it 'raises an exception when it is greater than 1' do
      options = { band_height_percentage: 2.3 }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Band height percentage is greater than 1')
    end
  end

  context 'when passing the band blur radius percentage' do
    it 'sets the value when it is valid' do
      options = { band_blur_radius_percentage: 5.5 }

      config = configuration.create(action.available_options, options)

      expect(config[:band_blur_radius_percentage]).to eq(options[:band_blur_radius_percentage])
    end

    it 'raises an exception when it is less than 0' do
      options = { band_blur_radius_percentage: -3.0 }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Band blur radius percentage is less than 0')
    end
  end

  context 'when passing the band blur sigma percentage' do
    it 'sets the value when it is valid' do
      options = { band_blur_sigma_percentage: 0.5 }

      config = configuration.create(action.available_options, options)

      expect(config[:band_blur_sigma_percentage]).to eq(options[:band_blur_sigma_percentage])
    end

    it 'raises an exception when it is less than 0' do
      options = { band_blur_sigma_percentage: -2.5 }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Band blur sigma percentage is less than 0')
    end

    it 'raises an exception when it is greater than 65355' do
      options = { band_blur_sigma_percentage: 65_356.0 }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Band blur sigma percentage is greater than 65355')
    end
  end
end
