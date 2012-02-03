# -*- coding: utf-8 -*-
require 'tengine/core'

class Driver100
  include Tengine::Core::Driveable

  on:event100
  def event100
    `echo "replace" >> ~/change_loaded_handler.log`
  end

end
