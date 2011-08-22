# -*- coding: utf-8 -*-
require 'tengine/core'

class Tengine::TestException < StandardError
end

Tengine.driver :driver1 do
  on:foo do
    raise Tengine::TestException, "exception at driver1.foo"
  end

  # 有効／無効について何も記述がないのでデフォルトで起動後に有効になります

end
