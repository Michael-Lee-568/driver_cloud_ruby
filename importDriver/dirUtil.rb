require 'securerandom'
require 'pathname'

module DirUtil
  # @param [父目录] parent_dir
    # @return [成功创建返回目录名，失败返回nil]
    def self.generate_uuid_dir (parent_dir)
    uuid_str=SecureRandom.uuid
    uuid_dir="#{parent_dir}/#{uuid_str}"
    if Dir.exist?(uuid_dir)
      p "created dir failed - #{uuid_dir} is exist"
      return nil
    else
      Dir.mkdir(uuid_dir)
      p "created dir successfully - #{uuid_dir}"
      return uuid_dir
    end
    end

    # @param [将要创建的目录] dir
    # @return [true|false]
    def self.generate_dir (dir)
      if Dir.exist?(dir)
        p "created dir failed - #{dir} is exist"
        return false
      else
        Dir.mkdir(dir)
        p "created dir successfully - #{dir}"
        return true
      end
    end
end

=begin
current_dir=Pathname.new(File.dirname(__FILE__)).realpath
parent_dir=File.join(current_dir, 'drivers')
p "parent_dir=#{parent_dir}"
DirUtil.generate_uuid_dir(parent_dir)
=end