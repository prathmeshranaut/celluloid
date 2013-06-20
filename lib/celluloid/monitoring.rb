require 'celluloid'

$CELLULOID_MONITORING = true

module Celluloid
  module Monitoring
    
    def self.pipe
      @pipe ||= Queue.new
    end
    
    def self.actor_created(actor)
      trigger_event(:actor_created, actor)
    end
    
    def self.actor_named(actor)
      trigger_event(:actor_named, actor)
    end
    
    def self.actor_died(actor)
      trigger_event(:actor_died, actor)
    end
    
    def self.actors_linked(a, b)
      a = find_actor(a)
      b = find_actor(b)
      trigger_event(:actors_linked, a, b)
    end

  private
    def self.trigger_event(name, *args)
      pipe << [name, args]
    end
    
    def self.find_actor(obj)
      if obj.__send__(:class) == Actor
        obj
      elsif owner = obj.instance_variable_get(OWNER_IVAR)
        owner
      end
    end
    
  end
end
