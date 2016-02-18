class DevicesController < ApplicationController
  
  @@usekey  = 'ML96T5X7IBRSY4IY'
  @@thingspeak = 'http://www.tsiots.com:3000'
  @@port = 3000
  def index
    @chlist  = getChannelListjson
    
   
    
  end
  
  def run
    #system("/home/ubuntu/workspace/a.out " + " -b " + " " + params[:mac] + " -I "  + " &") 
   
    
    
      url =   @@thingspeak + "/channels/#{params[:id]}"
      uri = URI(url)
      http = Net::HTTP.new(uri.host, @@port)
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
      http = Net::HTTP.new(uri.host, @@port)
      #http.use_ssl = true
      req = Net::HTTP::Put.new(uri.path)
      req.set_form_data({'api_key'=> @@usekey,'metadata' => create_metadata_json("stop",params[:api_key]) })
      http.request(req)
      redirect_to action: 'index'
  
  
    
  end
  
  
  def new
    
    ch  = create_a_channel()
    
    if(params[:device_type]=="Actuator")
      d = 0
    else 
      d= 1
    end
      
      
    if(params[:device]=="Switch Actuator" || params[:device]=="Switch Sensor")
      e=1
    elsif(params[:device]=="Temperature Sensor")
      e=2
    elsif(params[:device]=="Gas Sensor")
      e=3
    elsif(params[:device]=="Luminosity Sensor")
      e=4
    elsif(params[:device]=="PM Sensor")
      e=5
    end
  
    paramsdata = params[:mac] +" "+ ch['api_key'] + " " + d.to_s + " " + e.to_s  
    
    
    url = @@thingspeak + "/channels/#{ch['id']}"
    uri = URI(url)
    http = Net::HTTP.new(uri.host, @@port)
    #http.use_ssl = true
    req = Net::HTTP::Put.new(uri.path)
    req.set_form_data({'api_key'=> @@usekey,'metadata' =>  paramsdata  })
    res = http.request(req)
    puts res.body
 
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
      'description' => params[:description], 'field1' => params[:device],'field2' =>'field2','field3' =>'field3' ,'field8' => "field8", 'public_flag' =>'true' )
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
      http = Net::HTTP.new(uri.host,@@port)
      #http.use_ssl = true
      req = Net::HTTP::Delete.new(uri.path)
      req.set_form_data({'api_key'=> @@usekey})
      res = http.request(req)
      puts "deleted #{res}"
    end
    
end
  
 