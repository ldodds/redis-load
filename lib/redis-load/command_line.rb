module RedisLoad
  
  #This class acts as an adapter, taking parameters and environment variables and 
  #using those to drive an instance of RedisLoad::Loader  
  class CommandLine
    
    def initialize(opts, env)
      @opts = opts
      @env = env
      
      opts = Hash.new
      opts[:host] = @opts["host"] if @opts["host"]
      opts[:port] = @opts["port"] if @opts["port"]
      opts[:db] = @opts["database"] if @opts["database"]
      opts[:password] = @opts["password"] if @opts["password"]              
        
      @redis = Redis.new(opts)
      @loader = RedisLoad::Loader.new(@redis)
                
    end
    
    def load_json()
      puts "Loading data from JSON file #{@opts["file"]} into server"
      counter = @loader.load_json( @opts["file"], @opts["jsonpath"] )
      puts "#{counter} keys loaded."      
    end
    
    def load_list()
      puts "Loading #{@opts["file"]} into list #{@opts["key"]} into server"
      counter = @loader.load_list( @opts["key"] , @opts["file"] )
      puts "#{counter} lines loaded."
    end
    
    def save_list()
      puts "Saving list #{@opts["key"]} into #{@opts["file"]}"
      size = @loader.save_list( @opts["key"], @opts["file"] )
      puts "#{size} lines saved."      
    end
    
    def load_keys()
      puts "Loading keys from #{@opts["file"]} into server"
      counter = @loader.load_keys( @opts["file"] )
      puts "#{counter} lines loaded."
    end

    def load_set()
      puts "Loading #{@opts["file"]} into set #{@opts["key"]} on server"
      counter = @loader.load_set( @opts["key"], @opts["file"] )
      puts "#{counter} lines loaded."
    end

    def save_json()      
      puts "Saving json into #{@opts["file"]}"
      keys = @opts["keys"] || "*"      
      counter = @loader.save_json( @opts["file"], keys )
      puts "#{counter} keys saved."      
    end
    
    def save_set()
      puts "Saving set #{@opts["key"]} into #{@opts["file"]}"
      size = @loader.save_set( @opts["key"], @opts["file"] )
      puts "#{size} items saved."      
    end
  
    def load_zset()
      puts "Loading #{@opts["file"]} into sorted set #{@opts["key"]} on server"
      counter = @loader.load_zset( @opts["key"], @opts["file"] )
      puts "#{counter} items loaded."
    end

    def save_zset()
      puts "Saving set #{@opts["key"]} into #{@opts["file"]}"
      size = @loader.save_zset( @opts["key"], @opts["file"] )
      puts "#{size} items saved."  
    end                      

  end
end