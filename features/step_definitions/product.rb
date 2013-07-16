# encoding: utf-8

Given /^the custom taxons and custom products exist$/ do
  Fixtures.reset_cache
  fixtures_folder = File.join(Rails.root.to_s, 'db', 'sample')
  fixtures = Dir[File.join(fixtures_folder, '*.yml')].map {|f| File.basename(f, '.yml') }
  Fixtures.create_fixtures(fixtures_folder, fixtures)
=begin
  PaymentMethod.create(
  :name => 'Credit Card',
  :description => 'Bogus payment gateway for development.',
  :environment => 'cucumber',
  :active => true,
  :type => Gateway::Bogus)
=end
end

Then /^verify products listing for top search result$/ do
  page.all('ul.product-listing li').size.should == 1
  tmp = page.all('ul.product-listing li a').map(&:text).flatten.compact
  tmp.delete("")
  tmp.sort!.should == ["Ruby on Rails Ringer T-shirt $17.99"]
end

Then /^verify products listing for Ruby on Rails brand$/ do
  page.all('ul.product-listing li').size.should == 7
  tmp = page.all('ul.product-listing li a').map(&:text).flatten.compact
  tmp.delete("")
  array = ["Ruby on Rails Bag $22.99",
   "Ruby on Rails Baseball Jersey $19.99",
   "Ruby on Rails Jr. Spaghetti $19.99",
   "Ruby on Rails Mug $13.99",
   "Ruby on Rails Ringer T-shirt $17.99",
   "Ruby on Rails Stein $16.99",
   "Ruby on Rails Tote $15.99"]
  tmp.sort!.should == array
end

Then /^verify products listing for Ruby brand$/ do
  page.all('ul.product-listing li').size.should == 1
  tmp = page.all('ul.product-listing li a').map(&:text).flatten.compact
  tmp.delete("")
  tmp.sort!.should == ["Ruby Baseball Jersey $19.99"]
end

Then /^verify products listing for Apache brand$/ do
  page.all('ul.product-listing li').size.should == 1
  tmp = page.all('ul.product-listing li a').map(&:text).flatten.compact
  tmp.delete("")
  tmp.sort!.should == ["Apache Baseball Jersey $19.99"]
end

Then /^verify products listing for Clothing category$/ do
  page.all('ul.product-listing li').size.should == 5
  tmp = page.all('ul.product-listing li a').map(&:text).flatten.compact
  tmp.delete("")
  tmp.sort!.should == ["Apache Baseball Jersey $19.99",
 "Ruby Baseball Jersey $19.99",
 "Ruby on Rails Baseball Jersey $19.99",
 "Ruby on Rails Jr. Spaghetti $19.99",
 "Ruby on Rails Ringer T-shirt $17.99"]
end

Then /^verify products listing for Bags category$/ do
  page.all('ul.product-listing li').size.should == 2
  tmp = page.all('ul.product-listing li a').map(&:text).flatten.compact
  tmp.delete("")
  tmp.sort!.should == ["Ruby on Rails Bag $22.99", "Ruby on Rails Tote $15.99"]
end

Then /^verify products listing for Mugs category$/ do
  page.all('ul.product-listing li').size.should == 2
  tmp = page.all('ul.product-listing li a').map(&:text).flatten.compact
  tmp.delete("")
  tmp.sort!.should == ["Ruby on Rails Mug $13.99", "Ruby on Rails Stein $16.99"]
end

Then /^verify products listing for price range search 15-18$/ do
  page.all('ul.product-listing li').size.should == 3
  tmp = page.all('ul.product-listing li a').map(&:text).flatten.compact
  tmp.delete("")
  tmp.sort!.should == ["Ruby on Rails Ringer T-shirt $17.99", "Ruby on Rails Stein $16.99", "Ruby on Rails Tote $15.99"]
end

Then /^verify products listing for price range search 18 and above$/ do
  page.all('ul.product-listing li').size.should == 3
  tmp = page.all('ul.product-listing li a').map(&:text).flatten.compact
  tmp.delete("")
  tmp.sort!.should == ["Ruby on Rails Bag $22.99",
                       "Ruby on Rails Baseball Jersey $19.99",
                       "Ruby on Rails Jr. Spaghetti $19.99"]
end


Then /^I should get a "(\d+) ([^"]+)" response$/ do |http_status, message|
  #response.status.should == "#{http_status} #{message}"    # webrat
  page.driver.status_code.should == http_status.to_i        # capybara
end

When /^change currency to "([^"]*)"$/ do |arg1|
    visit "/currency/#{arg1}"
end

Then /^show page$/ do
    save_and_open_page
end

When /^push "add to cart"$/ do
  page.find(:xpath, "//button").click
end

When /^click checkout$/ do
  page.find(:xpath,"//a[@href='/checkout']").click
end

When /^I press Continue$/ do
  page.find(:xpath,"//input[@value='Continue']").click
end

When /^I press Save and Continue$/ do
  page.find(:xpath,"//input[@value='Save and Continue']").click
end

Then /^sleep$/ do
  sleep 100
end
