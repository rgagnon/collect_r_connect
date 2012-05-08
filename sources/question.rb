class Question < SourceAdapter
  def initialize(source) 
     @base = 'http://localhost:3001/questions'
     super(source)
  end
    
  def login
    # TODO: Login to your data source here if necessary
  end
 
    def query
      parsed=JSON.parse(RestClient.get("#{@base}.json").body)

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
    result = RestClient.post(@base, :product => create_hash)

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

    puts 'METADATA'
    
    objectlink = { :type => "linkli", :uri => "{{showuri}}", :text => "{{name}}" }
    list = { :type => "list", :children => [objectlink], :repeatable => "{{@products}}" }
    content = { :type => "content", :children => [list] }
    toolbar = { :title => 'REMI TITLE', :type => "toolbar", :left_uri => "/app", :right_uri => "/app/Product/new", :left_text => "Test", :right_text => "New"}
    index = { :title => "Remi index", :type => "view", :children => [toolbar, content]}
 
   
    ## NEW
    
    ###Shared with NEW and EDIT
    productname = { :type => 'labeledinputli',
      :label => 'Name',
      :name => 'product[name]',
      :value => '{{@product/name}}' }
    
    ##End Shared
    
    newlist = { :type => 'list',
      :children => [ productname ] }
    
    newsubmit = { :type => 'submit',
      :value => 'Create' }
    
    newhiddenid = { :type => 'hidden',
      :name => 'id',
      :value => '{{@product/object}}' }
    
    newform = { :type => 'form',
      :action => '/app/Company/create',
      :method => 'POST',
      :children => [newhiddenid, newlist, newsubmit] }
    
    newcontent = { :type => 'content',
      :children => [ newform ] } 
    
    newtoolbar = { :title => 'New', :type => 'toolbar',
      :lef_turi => '/app/Company',
      :left_text => 'Cancel',
      :left_class => 'backButton',
      :right_uri => '/app',
      :right_text => 'Home' }
    
    new = { :title => 'index',
      :type => 'view',
      :children => [newtoolbar,newcontent] }
    ##END NEW
    
    ##SHOW
    showproductname = { :type => 'labeledvalueli',
      :label => 'Name',
      :value => '{{@product/name}}' }
    
    
    showlist = { :type => 'list',
      :children => [ showproductname ] }
    
    
    showcontent = { :type => 'content',
      :children => [ showlist ] } 
    
    showtoolbar = { :title => '{{@product/name}}', 
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
      :action => '/app/Company/update',
      :method => 'POST',
      :children => [newhiddenid, newlist, editsubmit] }
    
    editcontent = { :type => 'content',
      :children => [ editform ] } 
    
    edittoolbar = { :title => '{{@product/name}}', :type => 'toolbar',
      :left_uri => '/app/Company',
      :left_text => 'Cancel',
      :left_class => 'backButton',
      :right_uri => '{{@product/deleteuri}}',
      :right_text => 'Delete' }
    
    edit = { :title => 'index',
      :type => 'view',
      :children => [edittoolbar,editcontent] }
    ## END UPDATE

    {'index' => index, 'new' => new, 'show' => show, 'edit' => edit }.to_json
 
    
  end
 
 
  def logoff
    # TODO: Logout from the data source if necessary
  end
end