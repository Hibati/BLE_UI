class DevicesController < ApplicationController
  
  @@usekey  = 'YG0DPTL0P8EWPQJ1'
  @@thingspeak = 'http://localhost:3000'
  def index
    @chlist  = getChannelListjson
    
   
    
  end
  
  def run
    #system("/home/ubuntu/workspace/a.out " + " -b " + " " + params[:mac] + " -I "  + " &") 
   
    
    
      url =   @@thingspeak + "/channels/#{params[:id]}"
      uri = URI(url)
      http = Net::HTTP.new(uri.host, 3000)
      #http.use_ssl = true
      req = Net::HTTP::Put.new(uri.path)
      puts params[:api_key] + "fghfghfghfghgfh"
      req.set_form_data({'api_key'=> @@usekey,'metadata' => create_metadata_json("running",params[:api_key]) })
      res = http.request(req)
      puts res
    redirect_to action: 'index'
  end
  def stop
  
  
      url = @@thingspeak + "/channels/#{params[:id]}"
      uri = URI(url)
      http = Net::HTTP.new(uri.host, 3000)
      #http.use_ssl = true
      req = Net::HTTP::Put.new(uri.path)
      req.set_form_data({'api_key'=> @@usekey,'metadata' => create_metadata_json("stop",params[:api_key]) })
      http.request(req)
      redirect_to action: 'index'
  
  
    
  end
  
  
  def new
    
    ch  = create_a_channel()
    
    my_hash = Hash.new
    my_hash = {:device_type => params[:device]  ,:mac => params[:mac] , :status => "stop" , :api_key =>ch['api_key'] }
    
    
    url = @@thingspeak + "/channels/#{ch['id']}"
    uri = URI(url)
    http = Net::HTTP.new(uri.host, 3000)
    #http.use_ssl = true
    req = Net::HTTP::Put.new(uri.path)
    req.set_form_data({'api_key'=> @@usekey,'metadata' =>  JSON.generate(my_hash)  })
    res = http.request(req)
    puts res
 
    redirect_to action: 'index'
  end
  
  def delete
  
  
      # delete the channel
     
        delete_a_channel(params[:id])
        
        # kill the program by given pid
        # delete the record in the database 
     
    
      redirect_to action: 'index'
  end

private
  
    def getChannelListjson()
        uri = URI(@@thingspeak + '/channels.json')
        params = { 'api_key' => @@usekey}
        uri.query = URI.encode_www_form(params)
        res = Net::HTTP.get_response(uri)
        return res.body
    end  
    
    
    def create_a_channel
      
     
      if params[:mac].length >1
         
      uri = URI(@@thingspeak + '/channels')
      res = Net::HTTP.post_form(uri, 'api_key' => @@usekey, 'name' => params[:device],
      'description' => params[:description], 'field1' => params[:device],'field2' =>'field2','field3' =>'field3' ,'field8' => "field8", 'public_flag' =>'true',
      'metadata' => create_metadata_json("stop","null") )
      str  = JSON.parse( res.body)
      puts str['id'] # id
      puts str['api_keys'][0]['api_key'] # api_key
      channel = Hash.new
      channel['api_key'] = str['api_keys'][0]['api_key']
      channel['id'] = str['id'] 

      return channel
      # p  @@thread[@@thread.length-1]
      end
    end
    
    
    def delete_a_channel(cid)
  
      url = @@thingspeak + '/channels/'+ cid.to_s
      uri = URI(url)
      http = Net::HTTP.new(uri.host, 3000)
      #http.use_ssl = true
      req = Net::HTTP::Delete.new(uri.path)
      req.set_form_data({'api_key'=> @@usekey})
      res = http.request(req)
      puts "deleted #{res}"
    end
    
    def create_metadata_json(status,api_key)
     
      my_hash = Hash.new
      my_hash = {:device_type => params[:device]  ,:mac => params[:mac] , :status => status , :api_key => api_key }
    
     # return  "{\"mac\": \"#{params[:mac]}\" , \"status\": \"#{status}\"}"
      return  JSON.generate(my_hash) 
    end
end
  
 