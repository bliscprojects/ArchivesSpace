require 'spec_helper'

describe 'Exports controller' do

  before(:each) do
    # EAD export normally tries the search index first, but for the tests we'll
    # skip that since Solr isn't running.
    allow(Search).to receive(:records_for_uris) do |*|
      {'results' => []}
    end
  end

  it "lets you export an Agent as EAC, even when it is linked to records from another repo" do

    accession = create(:json_accession)

    create(:json_event,
           'linked_agents' => [{'ref' => '/agents/software/1', 'role' => 'validator'}],
           'linked_records' => [{'ref' => accession.uri, 'role' => 'source'}])


    get "/repositories/#{$repo_id}/archival_contexts/softwares/1.xml"
    expect(last_response).to be_ok
    expect(last_response.body).to include("<eac-cpf")
  end


  it "lets you export a person in EAC-CPF" do
    id = create(:json_agent_person).id
    get "/repositories/#{$repo_id}/archival_contexts/people/#{id}.xml"
    resp = last_response.body
    expect(resp).to include("<eac-cpf")
    expect(resp).to include("<control>")
    expect(resp).to include("<entityType>person</entityType>")
  end


  it "lets you export a family in EAC-CPF" do
    id = create(:json_agent_family).id
    get "/repositories/#{$repo_id}/archival_contexts/families/#{id}.xml"
    resp = last_response.body
    expect(resp).to include("<eac-cpf")
    expect(resp).to include("<control>")
    expect(resp).to include("<entityType>family</entityType>")
  end


  it "lets you export a corporate entity in EAC-CPF" do
    id = create(:json_agent_corporate_entity).id
    get "/repositories/#{$repo_id}/archival_contexts/corporate_entities/#{id}.xml"
    resp = last_response.body
    expect(resp).to include("<eac-cpf")
    expect(resp).to include("<control>")
    expect(resp).to include("<entityType>corporateBody</entityType>")
  end


  it "lets you export a software in EAC-CPF" do
    id = create(:json_agent_software).id
    get "/repositories/#{$repo_id}/archival_contexts/softwares/#{id}.xml"
    resp = last_response.body
    expect(resp).to include("<eac-cpf")
    expect(resp).to include("<control>")
    expect(resp).to include("<entityType>software</entityType>")
  end


  it "lets you export a resource in EAD" do
    res = create(:json_resource, :publish => true)
    get "/repositories/#{$repo_id}/resource_descriptions/#{res.id}.xml"
    expect(last_response.body).to include("<ead")
  end


  it "excludes unpublished records in EAD exports by default" do

    resource = create(:json_resource)
    id = resource.id

    aos = []
    ["earth", "australia", "canberra"].each do |name|
      ao = create(:json_archival_object, {:title => "archival object: #{name}",
                                          :resource => {:ref => resource.uri}})
      if not aos.empty?
        ao.parent = {:ref => aos.last.uri}
        ao.publish = false
      end

      ao.save
      aos << ao
    end

    get "/repositories/#{$repo_id}/resource_descriptions/#{id}.xml"
    expect(last_response.body).not_to include("australia")
  end


  it "includes unpublished records in EAD exports upon request" do

    resource = create(:json_resource)
    id = resource.id

    aos = []
    ["earth", "australia", "canberra"].each do |name|
      ao = create(:json_archival_object, {:title => "archival object: #{name}",
                                          :resource => {:ref => resource.uri}})

      if not aos.empty?
        ao.parent = {:ref => aos.last.uri}
        ao.publish = false
      end

      ao.save
      aos << ao
    end

    get "/repositories/#{$repo_id}/resource_descriptions/#{id}.xml?include_unpublished=true"
    resp = last_response.body
    expect(resp).to include("australia")
    expect(resp).to include("audience=\"internal\"")
  end


  it "lets you export a resource in MARC 21" do
    res = create(:json_resource)
    get "/repositories/#{$repo_id}/resources/marc21/#{res.id}.xml"
    expect(last_response.body).to include("<subfield code=\"a\">#{res.id_0}")
  end


  it "lets you export labels for a resource as tab separated values" do
    resource= create(:json_resource)

    # create the record with all the instance/container etc
    location = create(:json_location, :temporary => generate(:temporary_location_type))
    status = 'current'

    container_profile = create(:json_container_profile)

    top_container = create(:json_top_container,
                           :container_profile => {'ref' => container_profile.uri},
                           :container_locations => [{'ref' => location.uri,
                                                      'status' => status,
                                                      'start_date' => generate(:yyyy_mm_dd),
                                                      'end_date' => generate(:yyyy_mm_dd)}])

    archival_object = create(:json_archival_object,
                             :resource => { :ref => resource.uri },
                             :instances => [build(:json_instance,
                                                  :sub_container => build(:json_sub_container,
                                                                          :top_container => {:ref => top_container.uri}))]
                             )

    id = resource.id
    get "/repositories/#{$repo_id}/resource_labels/#{id}.tsv"
    resp = last_response.body

    # it should have the headers...
    headers = "Repository Name\tResource Title\tResource Identifier\tSeries Archival Object Title\tArchival Object Title\tContainer Profile\tTop Container\tTop Container Barcode\tSubContainer 1\tSubContainer 2\tCurrent Location"
    expect(resp).to include("#{headers}")

    # it should have our location
    expect(resp).to include("#{location.title}")

    # it should have all our tc info
    expect(resp).to include(Regexp.escape( container_profile.name ))
    expect(resp).to include(Regexp.escape( top_container.indicator ))
    expect(resp).to include(Regexp.escape( top_container.type ))

    # it should have our top container info
    sub = archival_object.instances.first["sub_container"]

    expect(resp).to include( Regexp.escape( sub["type_2"] ))
    expect(resp).to include( Regexp.escape( sub["type_3"] ))

    expect(resp).to include( Regexp.escape( sub["indicator_2"] ))
    expect(resp).to include( Regexp.escape( sub["indicator_3"] ))

  end



  it "lets you export a digital object in MODS" do
    dig = create(:json_digital_object)
    get "/repositories/#{$repo_id}/digital_objects/mods/#{dig.id}.xml"
    expect(last_response.body).to include("<title>#{dig.title}</title>")
  end


  it "lets you export a digital object in METS" do
    dig = create(:json_digital_object)
    get "/repositories/#{$repo_id}/digital_objects/mets/#{dig.id}.xml"
    expect(last_response.body).to match(/<mods:title.*>#{dig.title}<\/mods:title>/)
  end


  it "lets you export a digital object in Dublin Core" do
    dig = create(:json_digital_object)
    get "/repositories/#{$repo_id}/digital_objects/dublin_core/#{dig.id}.xml"
    expect(last_response.body).to include("<title>#{dig.title}</title>")
  end


  it "gives you metadata for any kind of export" do
    # agent exports
    agent = create(:json_agent_person).id
    check_metadata("archival_contexts/people/#{agent}.xml")
    agent = create(:json_agent_family).id
    check_metadata("archival_contexts/families/#{agent}.xml")
    agent = create(:json_agent_corporate_entity).id
    check_metadata("archival_contexts/corporate_entities/#{agent}.xml")
    agent = create(:json_agent_software).id
    check_metadata("archival_contexts/softwares/#{agent}.xml")

    # resource exports
    res = create(:json_resource, :publish => true).id
    check_metadata("resource_descriptions/#{res}.xml")
    check_metadata("resources/marc21/#{res}.xml")
    check_metadata("resource_labels/#{res}.tsv")

    # digital object exports
    dig = create(:json_digital_object).id
    check_metadata("digital_objects/mods/#{dig}.xml")
    check_metadata("digital_objects/mets/#{dig}.xml")
    check_metadata("digital_objects/dublin_core/#{dig}.xml")
  end


  def check_metadata(export_uri)
    get "/repositories/#{$repo_id}/#{export_uri}/metadata"
    resp = ASUtils.json_parse(last_response.body)
    expect(resp).to have_key("mimetype")
    expect(resp).to have_key("filename")
  end

end
