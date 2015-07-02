require 'nokogiri'
require "open-uri"
require 'byebug'
require 'colorize'
require_relative 'post'
require_relative 'comment'
require_relative 'NoFileError'

ARGV
begin
  if !File.exist?(ARGV[0]) && !(!!(ARGV[0].downcase =~ /^(http)/))
    raise NoFileError, "File or Webpage does not exist"
  end
  page = Post.new(ARGV[0])
  puts "\n\n\n\nPost Title: ".colorize(:yellow) + "#{page.title}"
  puts "Number of Comments: ".colorize(:yellow) + "#{page.comments_array.length}"
  puts " - - - - - - - - - - - - - - -"
  puts "HN Points: ".colorize(:yellow) + "#{page.points}"+ "  |  " + "Post ID: ".colorize(:yellow) + "#{page.id[/\d+/]}\n\n\n\n"
rescue NoFileError => e
  puts e.message
  e.backtrace.each do |msg|
    puts msg
  end
end




