require 'csv'
module User::Operation
  class FileData < Trailblazer::Operation

    step :is_empty_file?
    fail :error_empty_file, fail_fast: true
    step :convert_file_to_json, Output(:success) => Track(:validate_data), Output(:failure) => Track(:error_in_json)
    step :convertion_error, magnetic_to: :error_in_json
    step :json_validate, magnetic_to: :validate_data

    def is_empty_file?(ctx, **)
      !File.zero?("test/files/test_file.csv")
    end

    def error_empty_file(ctx, **)
      p "File is empty."
    end

    def convert_file_to_json(ctx, **)
      headers = CSV.read("test/files/test_file.csv", headers: true).headers
      return true if headers == ['name', 'dob', 'mail']
      false
    end

    def convertion_error(ctx, **)
      csv = CSV.open('test/files/test_file.csv', 'w')
      csv << ['error while converting']
    end

    def json_validate(ctx,  **)
      csv = CSV.read('test/files/test_file.csv','a+')
      csv.shift
      csv.each do |row|
        age = Time.current.year -  Date.parse(row[1]).year
        if URI::MailTo::EMAIL_REGEXP.match?(row[2]) and age > 18
          User.create(name: row[0], age: age, email: row[2])
        else
          row << 'Invalidate validate_data'
        end
      end
    end
  end
end