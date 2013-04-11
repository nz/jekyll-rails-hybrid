require ::File.expand_path('../../../../config/environment',  __FILE__)

module Jekyll
  class RailsAssetPathTag < Liquid::Tag

    def initialize(tag_name, asset_name, tokens)
      super
      @asset_name = asset_name.strip
      @asset = Rails.application.assets[@asset_name]
      if @asset == nil
        $stderr.puts "Could not find '#{@asset_name}'"
      end
    end

    def render(context)
      begin
        if @asset
          "/assets/#{@asset.digest_path}"
        else
          ""
        end
      rescue Exception => e
        $stderr.puts e.message
        ""
      end
    end
  end
end

Liquid::Template.register_tag('asset_path', Jekyll::RailsAssetPathTag)
