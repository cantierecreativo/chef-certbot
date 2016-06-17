actions :create
default_action :create

attribute :domain, kind_of: String, required: true

attribute :email, kind_of: String, required: true

attribute :renew_policy,
          kind_of: Symbol,
          default: :keep_until_expiring,
          equal_to: [:keep_until_expiring, :renew_by_default]

attribute :install_cron,
          kind_of: [TrueClass, FalseClass],
          default: true

attribute :frequency,
          kind_of: Symbol,
          default: :daily,
          equal_to: [:daily, :weekly, :monthly]

attribute :test,
          kind_of: [TrueClass, FalseClass],
          default: false
