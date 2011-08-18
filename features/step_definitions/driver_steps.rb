Given /^the following drivers:$/ do |drivers|
  Tengine::Core::Driver.create!(drivers.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) driver$/ do |pos|
  visit drivers_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following drivers:$/ do |expected_drivers_table|
  expected_drivers_table.diff!(tableish('table tr', 'td,th'))
end
