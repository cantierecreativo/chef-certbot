actions :create
default_action :create

attribute :domain, kind_of: String, required: true, name_attribute: true
attribute :force_install, kind_of: [TrueClass, FalseClass], default: false
