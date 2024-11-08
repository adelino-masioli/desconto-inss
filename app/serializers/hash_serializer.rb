class HashSerializer
    def self.dump(hash)
      hash.to_json
    end
  
    def self.load(hash)
      return nil if hash.nil?
  
      JSON.parse(hash).with_indifferent_access
    rescue JSON::ParserError
      nil
    end
  end