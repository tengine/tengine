require 'tengine/core/config'

module Tengine::Core::Config::DB

  DEFAULT_SETTINGS = {
    "sessions"=>{
      "default"=>{
        "database"=>"tengine_production",
        "hosts"=>["localhost:27017"],
        "options"=>{
          "safe"=>true,
          "consistency"=>:strong
        }
      }
    }
  }.freeze

end
