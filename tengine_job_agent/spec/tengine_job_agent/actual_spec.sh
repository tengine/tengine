#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'time'

`echo \"#{Time.now.iso8601(6)}\" >> $HOME/actual_spec.log`
