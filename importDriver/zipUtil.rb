require 'rubygems'
require 'zip'
module ZipUtil
  def ZipUtil.unzip_file (file, destination)
    begin
      Zip::File.open(file) { |zip_file|
        zip_file.each { |f|
          f_path=File.join(destination, f.name)
          FileUtils.mkdir_p(File.dirname(f_path))
          zip_file.extract(f, f_path) unless File.exist?(f_path)
          puts "Extracted file name is #{f.name}"
        }
      }
      return true
    rescue => err
      puts err
      return false
    end
  end
end