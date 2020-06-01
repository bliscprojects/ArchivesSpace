class RequiredFields


  def self.get(record_type)
    uri = "/repositories/#{JSONModel.repository}/required_fields/#{record_type}"
    result = JSONModel::HTTP.get_json(uri)
    if result
      self.new(JSONModel(:required_fields).from_hash(result))
    else
      nil
    end
  end


  def self.from_hash(hash)
    self.new(JSONModel(:required_fields).from_hash(hash))
  end


  def initialize(json)
    @json = json
  end


  # We kind of cheat here: the form thinks 'lock_version' applies
  # to the archival record, but it's really for the required_fields
  # object
  def form_values
    values.merge({:lock_version => @json.lock_version})
  end


  def values
    @json.required || {}
  end


  def save
    uri = "/repositories/#{JSONModel.repository}/required_fields/#{@json.record_type}"
    url = URI("#{JSONModel::HTTP.backend_url}#{uri}")

    response = JSONModel::HTTP.post_json(url, ASUtils.to_json((@json.to_hash)))

    if response.code != '200'
      raise response.body
    end

    response
  end
end
