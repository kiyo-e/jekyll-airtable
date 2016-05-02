require "airtable"
module Airtable
  class Record
    def to_liquid
      attributes
    end
  end
end
