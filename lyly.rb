$:.unshift "."
require "object"
require "message"
require "method"

module Lyly
  def self.eval(code)
    message = Message.parse(code)
    message.call(Lobby) if message
  end
  
  def self.load(file)
    eval File.read(File.join(File.dirname(__FILE__), file))
  end
  
  load "boot.lyl"
end
