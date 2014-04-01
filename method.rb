module Lyly
  Lobby["Method"] = RuntimeObject.clone
  
  class Method < Object
    def initialize(message)
      @message = message
      super(Lobby["Method"])
    end
    
    def call(receiver, caller=receiver, *args)
      context = caller.clone
      context["self"] = receiver
      context["caller"] = caller
      context["arguments"] = Lobby["List"].clone(args)
      
      @message.call(context)
    end
  end
  
  # the method method
  Lobby["method"] = proc do |receiver, caller, message|
    Method.new(message)
  end
end
