#!/usr/bin/env jruby

$:.unshift "."

require "readline"
require "libs/object"
require "libs/message"
require "libs/method"

module Lyly
  def self.eval(code)
    message = Message.parse(code)
    message.call(Lobby) if message
  end
  
  def self.load(file)
    eval File.read(File.join(File.dirname(__FILE__), file))
  end
  
  load "test/boot.ly2"
end
