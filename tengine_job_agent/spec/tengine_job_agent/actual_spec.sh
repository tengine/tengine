#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'time'

`echo \"START    #{Time.now.iso8601(6)}\" >> $HOME/actual_spec.log`

sleep(10)

`echo \"FINISHED #{Time.now.iso8601(6)}\" >> $HOME/actual_spec.log`
