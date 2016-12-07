require 'mongo'

module MongodbUtil
  def self.insert(hash)
    begin
      #测试
      mongo_client=Mongo::Client.new([ '10.100.18.65:27021','10.100.18.87:27021','10.100.18.55:27021' ], :database => 'driver_cloud', :connect => :sharded)
      db_driver_cloud_normal_drivers=mongo_client[:normal_drivers]
      doc={:shardTag=>"-",
           :driverId=>"-",
           :originalHardwareId=>"-",
           :hardwareId=>"-",
           :driverType=>"-",
           :driverName=>"-",
           :driverVersion=>"-",
           :driverSize=>"-",
           :filePath=>"-",
           :remark=>"-",
           :mt=>"-",
           :os=>"-",
           :sn=>"-",
           :createdAt=>"-",
           :updatedAt=>"-",
           :isDeleted=>"-",
           :propertyTag=>"-",
           :sha256=>"-",
           :md5=>"-",
           :bus=>"-",
           :coreVersion=>"-",
           :pubtime=>"-",
           :parameter=>"-",
           :timeout=>"-",
           :bootFile=>"-",
           :type=>"-",
           :vender=>"-",
           :driverFrom=>"-",
           :driverWeight=>"-",
           :isVerified=>"-",
           :flag=>"-"
      }
      doc[:shardTag]="#{hash[:mt]}-#{hash[:os]}"
      doc[:driverId]=hash[:uuid]
      doc[:originalHardwareId]=hash[:originalHardwareId]
      #doc[:hardwareId]
      doc[:driverType]=hash[:driverType]
      doc[:driverName]=hash[:driverName]
      doc[:driverVersion]=hash[:driverVersion]
      doc[:driverSize]=hash[:driverSize]
      doc[:filePath]=hash[:filePath]
      doc[:mt]=hash[:mt]
      doc[:os]=hash[:os]
      #doc[:sn]=hash[:sn]
      doc[:createdAt]=DateTime.now
      doc[:updatedAt]=DateTime.now
      doc[:isDeleted]=0
      doc[:propertyTag]=1
      doc[:sha256]=hash[:sha256]
      doc[:md5]=hash[:md5]
      #doc[:bus]=hash[:bus]
      doc[:coreVersion]=hash[:coreVersion]
      doc[:pubtime]=DateTime.now
      doc[:parameter]=hash[:parameter]
      #doc[:timeout]=hash[:timeout]
      doc[:bootFile]=hash[:bootFile]
      #doc[:type]=hash[:type]
      doc[:vender]=hash[:vender]
      doc[:driverFrom]=hash[:driverFrom]
      doc[:driverWeight]=hash[:driverWeight]
      doc[:isVerified]=false
      #doc[:flag]=hash[:flag]
      puts "Insert MongoDB doc=#{doc}"
      result = db_driver_cloud_normal_drivers.insert_one(doc)
      return true
    rescue =>err
      puts err
      puts "Insert MongoDB doc=#{doc}"
      return false
    end
  end

end