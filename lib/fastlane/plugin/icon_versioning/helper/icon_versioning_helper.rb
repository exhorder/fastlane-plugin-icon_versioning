require 'fastlane_core/ui/ui'
require 'mini_magick'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?('UI')

  module Helper
    class IconVersioningHelper
      attr_accessor :appiconset_path
      attr_accessor :text

      attr_accessor :band_height_percentage
      attr_accessor :band_blur_radius_percentage
      attr_accessor :band_blur_sigma_percentage

      attr_accessor :ignored_icons_regex

      def initialize(params)
        self.appiconset_path = File.expand_path(params[:appiconset_path])
        self.text = params[:text]

        self.band_height_percentage = params[:band_height_percentage]
        self.band_blur_radius_percentage = params[:band_blur_radius_percentage]
        self.band_blur_sigma_percentage = params[:band_blur_sigma_percentage]

        self.ignored_icons_regex = params[:ignored_icons_regex]
      end

      def run()
        versioned_appiconset_path = self.class.get_versioned_path(self.appiconset_path)

        FileUtils.remove_entry(versioned_appiconset_path, force: true)
        FileUtils.copy_entry(self.appiconset_path, versioned_appiconset_path)

        Dir.glob("#{versioned_appiconset_path}/*.png").each do |icon_path|
          next if self.ignored_icons_regex && !(icon_path =~ self.ignored_icons_regex).nil?

          version_icon(icon_path)
        end
      end

      def self.get_versioned_path(path)
        return path.gsub(/([^.]+)(\.appiconset)/, '\1-Versioned\2')
      end

      private def version_icon(icon_path)
        image = MiniMagick::Image.open(icon_path)

        width = image[:width]
        height = image[:height]

        band_height = height * self.band_height_percentage
        band_blur_radius = width * self.band_blur_radius_percentage
        band_blur_sigma = width * self.band_blur_sigma_percentage

        band_top_position = height - band_height

        blurred_icon_path = suffix(icon_path, 'blurred')
        mask_icon_path = suffix(icon_path, 'mask')
        text_base_icon_path = suffix(icon_path, 'text_base')
        text_icon_path = suffix(icon_path, 'text')
        temp_icon_path = suffix(icon_path, 'temp')

        MiniMagick::Tool::Convert.new do |convert|
          convert << icon_path
          convert << '-blur' << "#{band_blur_radius}x#{band_blur_sigma}"
          convert << blurred_icon_path
        end

        MiniMagick::Tool::Convert.new do |convert|
          convert << blurred_icon_path
          convert << '-gamma' << '0'
          convert << '-fill' << 'white'
          convert << '-draw' << "rectangle 0, #{band_top_position}, #{width}, #{height}"
          convert << mask_icon_path
        end

        MiniMagick::Tool::Convert.new do |convert|
          convert << '-size' << "#{width}x#{band_height}"
          convert << 'xc:none'
          convert << '-fill' << 'rgba(0, 0, 0, 0.2)'
          convert << '-draw' << "rectangle 0, 0, #{width}, #{band_height}"
          convert << text_base_icon_path
        end

        MiniMagick::Tool::Convert.new do |convert|
          convert << '-background' << 'none'
          convert << '-size' << "#{width}x#{band_height}"
          convert << '-fill' << 'white'
          convert << '-gravity' << 'center'
          # using label instead of caption prevents wrapping long lines
          convert << "label:#{self.text}"
          convert << text_icon_path
        end

        MiniMagick::Tool::Convert.new do |convert|
          convert << icon_path
          convert << blurred_icon_path
          convert << mask_icon_path
          convert << '-composite'
          convert << temp_icon_path
        end

        File.delete(blurred_icon_path, mask_icon_path)

        MiniMagick::Tool::Convert.new do |convert|
          convert << temp_icon_path
          convert << text_base_icon_path
          convert << '-geometry' << "+0+#{band_top_position}"
          convert << '-composite'
          convert << text_icon_path
          convert << '-geometry' << "+0+#{band_top_position}"
          convert << '-composite'
          convert << icon_path
        end

        File.delete(text_base_icon_path, text_icon_path, temp_icon_path)
      end

      private def suffix(path, text)
        extension = File.extname(path)

        return path.gsub(extension, "_#{text}#{extension}")
      end
    end
  end
end
