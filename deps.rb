#!/usr/bin/env ruby

require 'asciidoctor'
require 'pp'
require 'set'

if ARGV.empty?
    puts("#{File.expand_path $0} <src> ...")
    exit(0)
end

def deps(src)
    ext = File.extname src
    doc = Asciidoctor.load_file src, :safe => :unsafe

    Set.new doc.references[:includes]
end

all = Set.new
ext = File.extname ARGV.first

ARGV.each do |src|
    reqs = deps(src)
    reqs = reqs.to_a
    reqs.map! { |i| i + ext }

    puts "$(STAMPDIR)/#{src}.stamp: #{src} #{reqs.join ' '}\n\t@touch $@"

    #puts "#{src}: #{reqs.join ' '}\n\ttouch $(STAMPDIR)/#{src}.stamp"
end
