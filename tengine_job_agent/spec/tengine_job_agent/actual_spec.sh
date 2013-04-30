#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'time'

`echo \"#{__FILE__} START #{Time.now.iso8601(6)}\" >> $HOME/actual_spec.log`

sleep(5)

`echo \"#{__FILE__} END   #{Time.now.iso8601(6)}\" >> $HOME/actual_spec.log`
