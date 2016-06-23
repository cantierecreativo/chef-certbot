actions :install
default_action :install

attribute :domain, kind_of: String
attribute :cert_path, kind_of: String, required: true
attribute :key_path, kind_of: String, required: true
