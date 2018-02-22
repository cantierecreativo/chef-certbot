actions :create
default_action :create

attribute :domain, kind_of: String, required: true, name_attribute: true

attribute(
  :time,
  kind_of: Symbol,
  default: :monthly,
  equal_to: [:daily, :weekly, :monthly]
)

attribute :environment, kind_of: Hash
attribute :mailto, kind_of: String
attribute :on_success, kind_of: String, default: "service nginx restart"
attribute :path, kind_of: String
