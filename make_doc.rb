#!/usr/bin/env ruby

puts "Creating documentation."
system "rdoc --title 'Term::ANSIColorHI' --main README -d README #{Dir['lib/**/*.rb'] * ' '}"
