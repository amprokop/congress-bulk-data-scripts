# gem install nokogiri

require 'open-uri'
require 'nokogiri'

# Bulk data is available at https://www.govinfo.gov/bulkdata. Unzip a file containing bill statuses and put it here.
xml_bill_statuses_dir_hr = '/Users/alex/Downloads/BILLSTATUS-116-hr'
xml_bill_statuses_dir_s = '/Users/alex/Downloads/BILLSTATUS-116-s'

introduced_count = 0
passed_by_house_count = 0
passed_by_senate_count = 0
became_law_count = 0

def was_signed_into_law?(doc)
    !!doc.xpath("//actionCode").find do |ac|
        ac.text == "E40000"
    end
end

def was_passed_by_chamber?(doc)
    !!doc.xpath("//actionCode").find { |ac| ac.text == "8000" }
end

def was_signed_into_law?(doc)
    !!doc.xpath("//actionCode").find { |ac| ac.text == "E40000" }
end


xml_bill_statuses_dir_hr

Dir.each_child(xml_bill_statuses_dir_hr) do |c|
    bill = Nokogiri::XML(File.open(xml_bill_statuses_dir_hr + '/' + c))
    introduced_count += 1
    if was_signed_into_law?(bill)
        became_law_count += 1
        puts bill.xpath('//billType').first.text + bill.xpath('//billNumber').first.text
    end
    if was_passed_by_chamber?(bill)
        passed_by_house_count += 1
    end
end
Dir.each_child(xml_bill_statuses_dir_s) do |c|
    bill = Nokogiri::XML(File.open(xml_bill_statuses_dir_s + '/' + c))
    introduced_count += 1
    if was_signed_into_law?(bill)
        became_law_count += 1
        puts bill.xpath('//billType').first.text + bill.xpath('//billNumber').first.text
    end

    if was_passed_by_chamber?(bill)
        passed_by_senate_count += 1
    end
end

puts "In the 116th Congress,"
puts introduced_count.to_s  + " bills were introduced."
puts passed_by_house_count.to_s + " bills were passed by the House."
puts passed_by_senate_count.to_s + " bills were passed by the Senate."
puts became_law_count.to_s + " bills became law."