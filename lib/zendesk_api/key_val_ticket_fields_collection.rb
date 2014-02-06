class ZendeskApi::KeyValTicketFieldsCollection
  extend ZendeskApi::TicketFieldsResource::CustomFieldsMapper

  def initialize(hash, repo)
    @hash = hash.symbolize_keys
    @repo = repo
  end

  def has_key?(title)
    @hash[title].present?
  end

  def [](title)
    @hash[title]
  end
  
  def merge(hash)
    @hash.merge!(hash)
  end

  def unexisting_fields
    existing_titles = @repo.map {|h| h["title"].to_sym }

    @hash.keys - existing_titles
  end

  def to_id_value_hashes
    @hash.keys.reduce([]) do |memo, title|
      value = @hash[title] 

      custom_field = self.class.custom_field_for(
        title.to_s.downcase,
        self.class.type_for(value),
        @repo)

      if custom_field
        memo << { 
          "id"    => custom_field["id"],
          "value" => self.class.value_for(custom_field["type"], value) }
      end

      memo
    end
  end

  def self.from_id_value_hashes(arr, repo)
    new(arr.inject({}) do |memo, hash|
      unless hash["value"].nil?
        field = repo.find {|f| f["id"] == hash["id"] }
        memo[field["title"]] = self.value_for(field["type"], hash["value"])
      end

      memo
    end, repo)
  end
end
