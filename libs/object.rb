# This is *The* Object, you create new object by cloning existing ones
# So you need One cloneable object, here it is : 

# Lyly object contain slot in which we can store methods & values

module Lyly
  class Object

    # attr_accessor automagically create getter/setter
    # See : http://www.rubyist.net/~slagell/ruby/accessors.html
    attr_accessor :slots, :proto, :value

    # our constructor (Called by Object.new)
    # the @ in @var doesn't mean it's an array (like some language)
    # it mean it's a instance variable.
    # See : http://www.rubyist.net/~slagell/ruby/instancevars.html
    def initialize(proto=nil, value=nil)
      @proto = proto		# empty proto
      @value = value            # empty value
      @slots = {}               # This is an empty hash : http://ruby.about.com/od/rubyfeatures/a/hashes.htm
    end
    
    ## Lookup a slot in the current object and protos.
    # Now this is weirdo stuff.
    # it define the [] method.
    # It's just syntaxic sugar to do this kind of stuff : 
    #   eg : foo = object["bar"]
    # object["bar"] is calling the [] methode with "bar" as parameter.
    # like : object.[]("bar")
    def [](name)
      begin
        return @slots[name] if @slots.key?(name)
        return @proto[name] if @proto
        raise "Missing slot: #{name}"
      rescue Exception => e  
        puts e.message
        puts e.backtrace.inspect  
      end
    end
    
    ## Set a slot
    # same as above, but to assigh a value, instead of getting it :
    #   eg : object["bar"] = "foo"
    # the 1st parameter (name) would be "bar" and the 2nd (message) would be "foo".
    # like object.[]=("bar","foo")
    def []=(name, value)
      @slots[name] = value
    end
    
    ## The call method is used to eval an object.
    ## By default objects eval to themselves.
    #def call(*)
    #  self
    #end
    
    # Of course, you can clone on object, that's the whole point of Lyly ;)
    # 1st : Why the clone method do a dup ?! 
    # Explanation : http://www.arnab-deka.com/posts/2009/07/ruby-dup-vs-clone/
    #
    # 2nd : the ||= thingy ?!
    # if val is nil then val become a dup of @value
    # the "@value && @value.dup" part is just to avoid dup'ing a nil if @value were nil.
    # if val is not nil, well... then val = val :)
    def clone(val=nil)
      #val ||= @value && @value.dup rescue TypeError
      Object.new(self, val)
    end
  end

  
  # define some basic method for the base of Lyly
  RuntimeObject = Object.new

  # The first thing a prototype based language is, obviously, a clone methode
  RuntimeObject["clone"] = proc do |receiver, caller|
    receiver.clone
  end
  
  # add method to a proto
  RuntimeObject["set"] = proc do |receiver, caller, name, value|
    name = name.call(caller).value
    receiver[name] = value.call(caller)
  end
  
  # print stuff \o/
  RuntimeObject["println"] = proc do |receiver, caller|
    puts receiver.value
    Lobby["nil"]
  end

  RuntimeObject["repl"] = proc do |receiver, caller|
    puts "Launching REPL : type \"die\" to exit."
    loop do
      line = Readline::readline(">> ")
      break if line == "die"
      Readline::HISTORY.push(line)
      message = Message.parse(line)
      value = message.call(Lobby) if line
      puts " => #{message.inspect}"
    end
  end

  RuntimeObject["die"] = proc do
    puts "Goodbye!"
    exit
  end

  # Lobby, where all object meet.
  Lobby = RuntimeObject.clone
  Lobby["Lobby"] = Lobby
  Lobby["Object"] = RuntimeObject
  Lobby["nil"] = RuntimeObject.clone(nil)	# nil is nil
  Lobby["true"] = RuntimeObject.clone(true)	# true is true
  Lobby["false"] = RuntimeObject.clone(false)	# false is false
  Lobby["Number"] = RuntimeObject.clone		# a number is an object
  Lobby["String"] = RuntimeObject.clone		# a string is an object
  Lobby["List"] = RuntimeObject.clone		# a list is an object
  
  Lobby["List"]["at"] = proc do |receiver, caller, index|
    index = index.call(caller).value
    array = receiver.value
    array[index]
  end
end
