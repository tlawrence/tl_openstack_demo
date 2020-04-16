#!/usr/bin/ruby
require 'ruby_terraform'

puts "NCA Environment Creation Demo\n\n"
puts "What Type Of Environment Do You Wish To Deploy?"

environment_types=[ "n3 multi-tier","lamp stack","mongo DB" ]

environment_types.each_with_index {|e,i| puts "  #{i+1}. #{e}"}
puts "\n\n\n"


selected_item = gets.to_i

puts "You Selected Item #{environment_types[selected_item-1]}, create (y/n)?" 

exit unless gets.match("y")

puts "\ncreating..\n"


git_url = 'git@github.com:UKCloud/terraform-n3-example.git'

puts "Enter an Environment Prefix (no spaces or special characters) e.g 'acme'"
environment_prefix = gets.chop

puts "Creating directory for environment #{environment_prefix}"


Dir.mkdir(environment_prefix) unless File.exists?(environment_prefix)

Dir.chdir(environment_prefix){
  puts "Executing Git Clone in #{Dir.pwd}"
  `git clone #{git_url}`
}

raise "Failed to clone repository" unless $?.success?

working_dir = "#{environment_prefix}/#{git_url.split('/').last.split('.').first}"

Dir.chdir(working_dir) {
  #`terraform init`
  #`terraform apply -var 'environment_prefix=#{environment_prefix}' -auto-approve`
  RubyTerraform.configure do |config|
    config.binary = '/usr/local/bin/terraform'
    end

  RubyTerraform.init
  RubyTerraform.apply(
    directory: Dir.pwd,
    auto_approve: true,
    vars: {
      environment_prefix: environment_prefix
  })
}


raise "Failed to run Terraform Apply" unless $?.success?
