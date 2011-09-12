require 'selectable_attr'
 require 'selectable_attr_i18n'
 require 'selectable_attr_rails'
# SelectableAttrRails.setup

SelectableAttrRails.logger = Rails.logger
SelectableAttr.logger = Rails.logger
SelectableAttrRails.add_features_to_action_view
