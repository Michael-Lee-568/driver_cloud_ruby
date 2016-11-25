require 'securerandom'
require 'pathname'

module DirUtil

    # @param [将要创建的目录] dir
    # @return [true|false]
    def self.generate_dir (dir)
      begin
        if Dir.exist?(dir)
          p "created dir failed - #{dir} is exist"
          return false
        else
          Dir.mkdir(dir)
          p "created dir successfully - #{dir}"
          return true
        end
      end
      return true
    rescue => err
      puts err
      return false
    end

  def self.traverse_dir_find_file(find_file,dir)
    begin
      file_array=[]
      if File.directory?(dir)
        Dir.foreach(dir) do |file|
          next if file=="." or file ==".."
          if File.directory?(file)
            traverse_dir_find_file(find_file,file)
          else
            file_array.push(Pathname.new(file).realpath) if find_file.to_s.downcase===file.to_s.downcase
          end
        end
      end
    end
    return file_array
  rescue => err
    puts err
    return nil
  end
end



=begin
current_dir=Pathname.new(File.dirname(__FILE__)).realpath
parent_dir=File.join(current_dir, 'drivers')
p "parent_dir=#{parent_dir}"
DirUtil.generate_uuid_dir(parent_dir)
=end