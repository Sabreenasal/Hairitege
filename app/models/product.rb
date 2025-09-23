# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  brand       :string
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Product < ApplicationRecord
  def self.import(file)
    raise "No file provided" unless file

    first_line = File.open(file.path, &:readline).strip
    raise "CSV file is empty" if first_line.empty?

    # Detect separator
    separators = [',', ';', "\t"]
    separator = separators.find { |sep| first_line.include?(sep) }

    separator ||= ',' # default to comma if none detected

    begin
      SmarterCSV.process(file.path, col_sep: separator) do |chunk|
        chunk.each do |row|
          Product.create!(row)
        end
      end
    rescue => e
      raise "Failed to import CSV: #{e.message}"
    end
  end
end
