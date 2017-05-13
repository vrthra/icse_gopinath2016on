#!/usr/bin/env ruby
pdf=ARGV[0]
def includetex(str)
  mystr = str.gsub(/^\\input\{([^{ }]+)\}/) do |inp|
    includetex(File.read("build/#{$1}.tex"))
  end
  return mystr
end


paper=includetex(File.read("build/#{pdf}.tex"))

puts paper.gsub(/\r/,'')
