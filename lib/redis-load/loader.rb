module RedisLoad
  
  #Exposes support for loading and saving different types of redis data 
  #structures to and from files  
  class Loader
    
    attr_reader :redis
    
    def initialize(redis)
      @redis = redis      
    end

    def load_keys(file)
      f = File.new( file )
      counter = process_lines(f) do |redis,line|
        line = line.chomp
        parts = line.split(",")
        redis.set( parts[0], parts[1] )
      end
      return counter
    end
    
    #Load the contents of a JSON file into Redis
    #
    #Each key in the JSON file becomes a redis key. If the value is a literal then this is added
    #as a redis key-value pair. If an array, then a List. If a hash, then a Hash. 
    #
    #Nested objects will be flattened.
    #
    #  file:: json file
    #  path:: optional, path in the json file indicating the subsection to load
    def load_json(file, path=nil)
      f = File.new( file )
      json = JSON.parse( f.read )
      if path != nil
        json = Siren.query(query, json)
      end
      counter = 0
      #TODO could support proper results, not just path?
      if json != nil
        json.each_pair do |key,value|
          if value.class() == Array
            value.each do |v|
              @redis.lpush( key, v )
            end          
          elsif value.class == Hash
            value.each_pair do |field, v|
              #TODO better handling of nesting?
              #E.g. convert hash or array back into JSON?
              @redis.hset(key, field, v)
            end
          else
            @redis.set(key, value)
          end
          counter = counter + 1      
        end        
      end
      return counter
    end
        
    #Load the contents of a file into a Redis list
    #
    #  key:: name of the list
    #  file:: name of file (string)
    def load_list(key, file)
      f = File.new( file )
      counter = process_lines(f) do |redis,line|
        redis.lpush( key , line.chomp)
      end
      return counter            
    end
    
    def load_set(key, file)
      f = File.new( file )
      counter = process_lines(f) do |redis,line|
        redis.sadd( key , line.chomp)
      end
      return counter
    end
    
    def load_zset(key, file)
      f = File.new( file )
      counter = process_lines(f) do |redis,line|
        line = line.chomp
        parts = line.split(",")
        redis.set( key , parts[1], parts[0] )
      end
      return counter
    end
    
    def save_list(key, file)
      size = @redis.llen( key )
      count = 0
      File.open( file , "w") do |file|
        while (count < size)
          file.puts( @redis.lindex(key , count) )
          count = count + 1
        end
      end
      return size      
    end
                    
    def save_set(key, file)
      members = @redis.smembers( key )
      File.open( file , "w") do |file|
        members.each do |m|
          file.puts(m)
        end
      end
      return members.length      
    end
        
    def save_zset(key, file)
      members = @redis.zrange( key , 0, -1, :with_scores => true)
      File.open( file , "w") do |file|
        members.each_slice(2) do |member,value|
          file.puts("#{member},#{value}")
        end
      end
      return members.length/2  
    end
    
    #Process lines
    #
    #  io:: IO Object
    def process_lines(io)
      counter = 0
      io.each_line do |line|
        yield @redis, line
        counter = counter + 1
      end
      return counter      
    end
        
  end
end