require "jekyll/airtable/version"

module Jekyll
  module Airtable
    class Generator < Jekyll::Generator
      def generate(site)
        table_key   = site.config.dig('airtable', 'table_key')
        table_name   = site.config.dig('airtable', 'table_name')
        credentials  = ENV['AIRTABLE_API_KEY']

        raise "No sheet specified for the Airtable Data Plugin\nSet 'airtable.table' in your '_config.yml'" unless table_key
        raise "No credentials specified for the Airtable Data Plugin\nSet it in a AIRTABLE_API_KEY environment variable\nEg.: export GDRIVE_TOKEN=<apikey>" unless credentials

        data = load_from_sheet(table_key, table_name, credentials)
        while data.last&.attributes&.size == 1
          data.pop
        end

        site.data['airtable'] = data
      end

      def load_from_sheet(table_key, table_name, credentials)
        client = ::Airtable::Client.new(credentials)
        table = client.table(table_key, table_name)
        table.records
      end

    end
  end
end
