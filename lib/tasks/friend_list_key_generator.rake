require 'fileutils'
require 'openssl'

namespace :friendlist do
  desc "Generate RSA key pair"
  task :generate_keys do
    key = OpenSSL::PKey::RSA.generate(2048)

    output_public = File.new(File.join(Rails.root, "config/friendlist_public.pem"), "w")
    output_public.puts key.public_key
    output_public.close

    output_private = File.new(File.join(Rails.root, "config/friendlist_private.pem"), "w")
    output_private.puts key.to_pem
    output_private.close
  end
end

