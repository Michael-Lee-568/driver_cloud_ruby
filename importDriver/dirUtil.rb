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

    @@boot_file_array=Array.new
    def self.reset_boot_file_array()
      @@boot_file_array.clear()
    end
  def self.traverse_dir_find_file(find_file,dir)
    begin
      puts "递归查找文件开始"
      #file_array=[]
      if File.directory?(dir)
        Dir.foreach(dir) do |file|
          next if file=="." or file ==".."
          file_path= File.join(dir,file)
          if File.directory? file_path
            traverse_dir_find_file(find_file,file_path)
          else
            puts file_path
            if find_file.to_s.downcase===file.to_s.downcase
              #file_array.push(file_path)
              @@boot_file_array.push(file_path)
              puts "push bootfile=#{file_path}"
            end
          end
        end
      end
    end
    puts "递归查找文件结束"
    return @@boot_file_array
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