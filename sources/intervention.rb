require 'json'
require 'rest_client'

class Intervention < SourceAdapter
  def initialize(source,credential)
     @base = 'http://localhost:3001/interventions'
    super(source,credential)
  end

  def login
    # puts "LOGIN USER: #{current_user.login}"
    # @sessionid = Store.get_value("#{current_user.login}:session")
    # endpoint_url = Store.get_value("#{current_user.login}:endpoint_url")

    # @resturl = endpoint_url + "/services/data/v20.0"
    # @restheaders = {
    #   "Accept" => "*/*", 
    #   "Authorization" => "OAuth #{@sessionid.split('!')[1]}", 
    #   "X-PrettyPrint" => "1"
    # }
    
    # @postheaders = {
    #   "Accept" => "*/*", 
    #   "Content-Type" => "application/json", 
    #   "Authorization" => "OAuth #{@sessionid.split('!')[1]}", 
    #   "X-PrettyPrint" => "1"
    # }
    
    # @fields = []
    # parsed=
    # JSON.parse(
    #   RestClient.get(
    #     "#{@resturl}/sobjects/Account/describe/", 
    #     @restheaders
    #   ).body
    # )
    
    # parsed["fields"].each do |field|
    #   puts "#{field["name"]}::#{field["type"]}::#{field["length"]}"
    #   @fields << field
    # end

  end

    def query
      parsed=JSON.parse(RestClient.get("#{@base}.json").body)
      require 'pp'

  pp parsed
      @result={}
      if parsed
        parsed.each do |item| 
          key = item["id"].to_s
          @result[key]=item
        end
      end 
    end
 
  def sync
    # Manipulate @result before it is saved, or save it 
    # yourself using the Rhoconnect::Store interface.
    # By default, super is called below which simply saves @result
    super
  end
 
  def create(create_hash)
    result = RestClient.post(@base, :intervention => create_hash)

    # after create we are redirected to the new record.
    # The URL of the new record is given in the location header
    location = "#{result.headers[:location]}.json"

    # We need to get the id of that record and return it as part of create
    # so rhoconnect can establish a link from its temporary object on the
    # client to this newly created object on the server

    new_record = RestClient.get(location).body
    JSON.parse(new_record)["intervention"]["id"].to_s
  end
   
  def update(update_hash)
    # TODO: Update an existing record in your backend data source
    raise "Please provide some code to update a single record in the backend data source using the update_hash"
  end
 
  def update(update_hash)
    # TODO: Update an existing record in your backend data source
    raise "Please provide some code to update a single record in the backend data source using the update_hash"
  end
 
  def delete(delete_hash)
    # TODO: write some code here if applicable
    # be sure to have a hash key and value for "object"
    # for now, we'll say that its OK to not have a delete operation
    # raise "Please provide some code to delete a single object in the backend application using the object_id"
  end
  def metadata

    puts 'METADATA Intervention'
    
    objectlink = { :type => "linkli", :uri => "/app/Form/?intervention_id={{object}}", :text => "Interventionss : {{object}}|{{intervention_type_name}}" }
    list = { :type => "list", :children => [objectlink], :repeatable => "{{@interventions}}" }
    content = { :type => "content", :children => [list] }
    toolbar = { :title => 'INTERVENTION', :type => "toolbar", :left_uri => "/app/Settings/do_sync", :right_uri => "/app/Intervention/index", :left_text => "Sync", :right_text => "List"}
    index = { :title => "Remi index", :type => "view", :children => [toolbar, content]}
 
   
    ## NEW
    
    ###Shared with NEW and EDIT
    intervention_type_id = { :type => 'labeledinputli',
      :label => 'intervention_type_id',
      :name => 'intervention[intervention_type_id]',
      :value => '{{@intervention/intervention_type_id}}' }

    intervention_site_id = { :type => 'labeledinputli',
      :label => 'intervention_site_id',
      :name => 'intervention[site_id]',
      :value => '{{@intervention/site_id}}' }
    
    ##End Shared
    
    newlist = { :type => 'list',
      :children => [ intervention_type_id, intervention_site_id ] }
    
    newsubmit = { :type => 'submit',
      :value => 'Create' }
    
    newhiddenid = { :type => 'hidden',
      :name => 'id',
      :value => '{{@intervention/object}}' }
    
    newform = { :type => 'form',
      :action => '/app/Intervention/create',
      :method => 'POST',
      :children => [newhiddenid, newlist, newsubmit] }
    
    newcontent = { :type => 'content',
      :children => [ newform ] } 
    
    newtoolbar = { :title => 'New', :type => 'toolbar',
      :lef_turi => '/app/Intervention',
      :left_text => 'Cancel',
      :left_class => 'backButton',
      :right_uri => '/app',
      :right_text => 'Home' }
    
    new = { :title => 'index',
      :type => 'view',
      :children => [newtoolbar,newcontent] }
    ##END NEW
    
    ##SHOW
    show_intervention_type_id = { :type => 'labeledvalueli',
      :label => 'Name',
      :value => '{{@intervention/intervention_type_id}}' }
    
    
    showlist = { :type => 'list',
      :children => [ show_intervention_type_id ] }
    
    
    showcontent = { :type => 'content',
      :children => [ showlist ] } 
    
    showtoolbar = { :title => '{{@intervention/intervention_type_id}}', 
      :type => 'toolbar',
      :left_uri => 'index',
      :left_text => 'Back',
      :left_class => 'backButton',
      :right_uri => 'edit',
      :right_text => 'Edit' }
    
    show = { :title => 'view',
      :type => 'view',
      :children => [showtoolbar,showcontent] }
    ## END SHOW
    
    ## edit
    
    editsubmit = { :type => 'submit',
      :value => 'Update' }
    
    
    #NOTE: see that we reuse newhiddenid and newlist components
    editform = { :type => 'form',
      :action => '/app/Intervention/update',
      :method => 'POST',
      :children => [newhiddenid, newlist, editsubmit] }
    
    editcontent = { :type => 'content',
      :children => [ editform ] } 
    
    edittoolbar = { :title => '{{@intervention/name}}', :type => 'toolbar',
      :left_uri => '/app/Intervention',
      :left_text => 'Cancel',
      :left_class => 'backButton',
      :right_uri => '{{@intervention/deleteuri}}',
      :right_text => 'Delete' }
    
    edit = { :title => 'index',
      :type => 'view',
      :children => [edittoolbar,editcontent] }
    ## END UPDATE

    require 'pp'
    pp ({'index' => index, 'new' => new, 'show' => show, 'edit' => edit })

    {'index' => index, 'new' => new, 'show' => show, 'edit' => edit }.to_json
 
    
  end
 
 
  def logoff
    # TODO: Logout from the data source if necessary
  end
end