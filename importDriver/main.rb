require 'roo'
require 'logger'
require 'pathname'
require 'securerandom'
#
require File.join(File.dirname(__FILE__), '/loggerUtil.rb')
require File.join(File.dirname(__FILE__), '/preDef.rb')
require File.join(File.dirname(__FILE__), '/dirUtil.rb')
require File.join(File.dirname(__FILE__), '/zipUtil.rb')
require File.join(File.dirname(__FILE__), '/sevenzipUtil.rb')
begin
#
log=LoggerUtil.new
#
p "ARGV.length=#{ARGV.length}"
#全局目录,一般为 ./
dir_global=""
#mt目录:like ./mt
dir_mt=""
#./mt目录下的具体导入机型,./mt/like:Lenovo_IdeaPad_710s-13ISK_20161124_1533
dir_mt_mt=""
#drivers目录
dir_drivers=""
#脚本执行的第二个参数中的时间信息,like:./drivers/20161124_1533 in Lenovo_IdeaPad_710s-13ISK_20161124_1533
dir_drivers_time=""
#脚本执行的第二个参数中的时间信息,like:20161124_1533 in Lenovo_IdeaPad_710s-13ISK_20161124_1533
dir_time_str=""
#脚本执行的第二个参数,like:Lenovo_IdeaPad_710s-13ISK_20161124_1533
mt_name=""
#日志文件,Lenovo_IdeaPad_710s-13ISK_20161124_1533.log
file_mt_log=""
#excel文件,Lenovo_IdeaPad_710s-13ISK_20161124_1533.xlsx
  file_mt_excel=""
if(ARGV.length==2)
  dir_global=ARGV[0]
  p "dir_global=#{dir_global}"
  dir_mt=File.join(dir_global,"mt")
  p "dir_mt=#{dir_mt}"
  dir_mt_mt=File.join(dir_mt,ARGV[1])
  p "dir_mt_mt=#{dir_mt_mt}"
  mt_name=ARGV[1]
  p "mt_name=#{mt_name}"
  dir_drivers=File.join(dir_global,"drivers")
  p "dir_drivers=#{dir_drivers}"
  file_mt_excel=File.join(dir_mt,"#{mt_name}.xlsx")
  p "file_mt_excel=#{file_mt_excel}"
  #判断需要的目录和Excel文件是否存在，参数二必须是带横杠的日期，如：Lenovo_IdeaPad_710s-13ISK_20161124_1533
  if(dir_global!=""&&dir_mt!=""&&dir_mt_mt!=""&&dir_drivers!=""&&dir_mt_mt.split('_').length>2&&Dir.exist?(dir_mt_mt)&&File.exist?(file_mt_excel))
    dir_time_array=dir_mt_mt.split('_')
    dir_time_str=dir_time_array[-2]+'_'+dir_time_array[-1]
    dir_drivers_time=File.join(dir_drivers,dir_time_str)
    p "dir_drivers_time=#{dir_drivers_time}"
    dir_drivers_timeunzip=File.join(dir_drivers,"#{dir_time_str}_unzip")
    p "dir_drivers_timeunzip=#{dir_drivers_timeunzip}"
    file_mt_log=File.join(dir_mt,"#{mt_name}.log")
    log.add(Logger.new(file_mt_log))
    log.info("dir_global=#{dir_global}")
    log.info("dir_drivers=#{dir_drivers}")
    log.info("dir_drivers_time=#{dir_drivers_time}")
    log.info("dir_drivers_timeunzip=#{dir_drivers_timeunzip}")
    log.info("dir_mt=#{dir_mt}")
    log.info("dir_mt_mt=#{dir_mt_mt}")
    log.info("mt_name=#{mt_name}")
    log.info("file_mt_excel=#{file_mt_excel}")
    log.info("!------------------------------------------------------------------------------------->>>")
    if(DirUtil.generate_dir(dir_drivers_time))
      log.info("[Yes]=> generate dir_drivers_time=#{dir_drivers_time}")
    else
      log.warn("[No]=> generate dir_drivers_time=#{dir_drivers_time}")
    end
    if(DirUtil.generate_dir(dir_drivers_timeunzip))
      log.info("[Yes]=> generate dir_drivers_timeunzip=#{dir_drivers_timeunzip}")
        #读Excel文件
        xlsx = Roo::Spreadsheet.open(file_mt_excel)
        log.info( "xlsx.info: #{xlsx.info}" )
        sheet=xlsx.sheet(0)
        row_num_hash=0
        sheet.each(driverName:'driverName',driverType: 'driverType', driverVersion: 'driverVersion',osStr:'osStr',os:'os',Vender:'Vender',coreVersion:'coreVersion',parameter:'parameter',driverFrom:'driverFrom') do |hash|
          #利用row_num_hash,跳过首行标题
          if (row_num_hash>0)
            log.info("row_num_hash=#{row_num_hash}")
            #查找操作系统文件夹
            dir_os=File.join(dir_mt_mt,hash[:osStr])
            if Dir.exist?(dir_os) then
              if dir_drivername=File.join(dir_os,hash[:driverName]) then
                #查找zip文件
                file_zip_name=""
                file_zip_path=""
                Dir.foreach(dir_drivername) do |file_name|
                  ext=File.extname(file_name)
                  if ext==".zip"
                    file_zip_name=file_name
                    break
                  else
                    next
                  end
                end
                hash[:zipFileName]=file_zip_name
                file_zip_path=File.join(dir_drivername,file_zip_name)
                hash[:zipFilePath]=file_zip_path
                #在./drivers/20161124_2309_unzip/目录，创建uuid文件夹，并解压zip文件到，uuid文件夹
                uuid_str=SecureRandom.uuid
                dir_drivers_timeunzip_uuid=File.join(dir_drivers_timeunzip,uuid_str)
                if(DirUtil.generate_dir(dir_drivers_timeunzip_uuid))
                  log.info("[Yes]=> generate dir_drivers_timeunzip_uuid=#{dir_drivers_timeunzip_uuid}")
                  #解压zip文件到uuid文件夹
                  if ZipUtil.unzip_file(file_zip_path,dir_drivers_timeunzip_uuid)
                    log.info("[Yes]=> 解压 #{file_zip_name}到#{dir_drivers_timeunzip_uuid}")
                    #查找bootfile
                    hash_parameter= hash[:parameter]
                    hash_parameter_array= hash_parameter.to_s.split(' ',2)
                    driver_exe_name=""
                    driver_exe_silence=""
                    if(hash_parameter_array.length>=2)
                      #获取驱动安装程序名称
                      driver_exe_name=hash_parameter_array[0].to_s.strip
                      driver_exe_silence=hash_parameter_array[1].to_s.strip
                      log.info("[Yes]=> 从Excel静默参数中提取驱动安装程序名称：driver_exe_name=#{driver_exe_name}")
                      log.info("[Yes]=> 从Excel静默参数中提取静默参数：driver_exe_silence=#{driver_exe_silence}")
                      #递归查找文件夹，拼接bootfile
                      boot_file_array=DirUtil.traverse_dir_find_file(driver_exe_name,dir_drivers_timeunzip_uuid)
                      if !boot_file_array.nil?
                        log.info("[Yes]=> 拼接bootfile: boot_file_array=#{boot_file_array}")
                      else
                        log.warn("[No]=> 拼接bootfile")
                        next
                      end
                    else
                      log.warn("[No]=> 从Excel静默参数中提取驱动安装程序和静默参数")
                      next
                    end
                    p Dir.entries(dir_drivers_timeunzip_uuid)
                    #将UUID文件夹，压缩成7Z，并存放到./drivers/20161124_2309目录下
                    file_7z_name="#{uuid_str}.bin"
                    file7z_drivers_time_uuid=File.join(dir_drivers_time,file_7z_name)
                    hash[:z7FileName]=file_7z_name
                    hash[:z7FilePath]=file7z_drivers_time_uuid
                    if SevenzipUtil.compress_file(file7z_drivers_time_uuid,dir_drivers_timeunzip_uuid)
                      #成功压缩成7Z文件
                      log.info("[Yes]=> 压缩7Z文件，file7z_drivers_time_uuid= #{file7z_drivers_time_uuid}")
                      #计算sha256,md5,文件大小
                    else
                      log.warn("[No]=> 压缩7Z文件 #{file7z_drivers_time_uuid}")
                      next
                    end
                  else
                    log.warn("[No]=> 解压 #{file_zip_name}到#{dir_drivers_timeunzip_uuid}")
                    next
                  end
                else
                  log.warn("[No]=> generate dir_drivers_timeunzip_uuid=#{dir_drivers_timeunzip_uuid}")
                  #读Excel下一行数据
                  next
                end
                #通过静默安装参数，查找驱动安装程序，创建bootfile属性
                log.info(hash)
              else
                #驱动文件夹不存在
                log.warn("驱动文件夹不存在:#{dir_drivername}")
              end
            else
              #操作系统文件夹不存在
              log.warn("操作系统文件夹不存在:#{dir_os}")
            end
          end
          row_num_hash=row_num_hash+1
        end
    else
      log.warn("[No]=> generate dir_drivers_timeunzip=#{dir_drivers_timeunzip}")
      return
    end
    log.info(">>>-------------------------------------------------------------------------------------!")
  else
    p "ERR -- script run failed! may be some dir(file) err or not exist"
    return
  end
else
  p "ERR -- script run failed! need the dir_globa and dir_mt_mt"
  return
end
  rescue => err
  puts err
  log.error(err);
end
=begin
xlsx = Roo::Spreadsheet.open('./sn_data.xlsx')




puts Pathname.new(File.dirname(__FILE__)).realpath
puts Pathname.new(__FILE__).realpath
current_dir=Pathname.new(File.dirname(__FILE__)).realpath
zipfile=File.join(current_dir, '/0NIO01WS.zip')
puts "zipfile=#{zipfile}"
unzip_dir=File.join(current_dir, '/ext')
puts "unzip_dir=#{unzip_dir}"
ZipUtil.unzip_file(zipfile,unzip_dir)
=end


#global/mt/Lenovo_XiaoXin_Air_Pro_13_20161124_1112
#global/mt/Lenovo_XiaoXin_Air_Pro_13_20161124_1112.excel
#global/mt/Lenovo_XiaoXin_Air_Pro_13_20161124_1112.log
#global/drivers/20161124_1112


#global/mt/Lenovo_XiaoXin_Air_Pro_13_v1
#global/mt/Lenovo_XiaoXin_Air_Pro_13_v1.excel
#global/mt/Lenovo_XiaoXin_Air_Pro_13_v1.log
#global/drivers/20161124_v1