Given /^the following drivers:$/ do |drivers|
  drivers.hashes.each do |hash|
    Tengine::Core::Driver.create!(hash)
  end
end

When /^I delete the (\d+)(?:st|nd|rd|th) driver$/ do |pos|
  visit tengine_core_drivers_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following drivers:$/ do |expected_drivers_table|
  expected_column_size = expected_drivers_table.rows.first.length
  actual = tableish('table tr', 'td,th')
  actual = actual.map{|row| row[0, expected_column_size]}
  expected_drivers_table.diff!(actual)
end
