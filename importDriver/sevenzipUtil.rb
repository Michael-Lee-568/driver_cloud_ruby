require "seven_zip_ruby"
require 'pathname'
require 'digest'

module SevenzipUtil
  def SevenzipUtil.compress_file (file_7z, dir)
    begin
      uuid=File.basename(file_7z, '.*')
      File.open(file_7z, "wb") do |file|
        SevenZipRuby::Writer.open(file) do |szr|
          szr.add_directory(dir,as: uuid)
        end
      end
      return true
    rescue => err
      puts err
      return false
    end
  end
end

=begin
current_dir=Pathname.new(File.dirname(__FILE__)).realpath
#file_7z=File.join(current_dir, '/7z/0NIO01WS.7z')
#zip_dir=File.join(current_dir, '/ext')
file_7z=File.join('.', '/7z/0NIO01WS.7z')
zip_dir=File.join('.', '/ext')
SevenzipUtil.compress_file(file_7z,zip_dir)
sha256 = Digest::SHA256.file file_7z
p "sha256=#{sha256}"
md5 = Digest::MD5.file file_7z
p "sha256=#{md5}"
file_7z_size=File.size(file_7z)
p "file_7z_size=#{file_7z_size}"
=end