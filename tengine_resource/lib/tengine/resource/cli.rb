# -*- coding: utf-8 -*-
require 'tengine/resource'

require 'thor'

class Tengine::Resource::CLI < Thor
  autoload :GlobalOptions, 'tengine/resource/cli/global_options'
  autoload :Server       , 'tengine/resource/cli/server'
  autoload :Credential   , 'tengine/resource/cli/credential'

  register(Server    , 'server'    , 'server <command>'    , 'Description.')
  register(Credential, 'credential', 'credential <command>', 'Description.')
end
