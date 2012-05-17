# -*- coding: utf-8 -*-
# create a model
Given(/^次の#{capture_model}が登録されている(?: #{capture_fields})?$/) do |capture_model, capture_fields|
  Given %{#{capture_model} exists with #{capture_fields}}
end

Given(/^以下の#{capture_plural_factory}が登録されている$/) do |capture_plural_factory, table|
  Given %{the following #{capture_plural_factory} exist}, table
end

