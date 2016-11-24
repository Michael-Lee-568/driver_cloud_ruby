require 'logger'

class LoggerUtil
  def initialize
    @logger_array=[Logger.new(STDOUT)]
  end

  def add(logger)
    if(logger.is_a? Logger)
        @logger_array.push(logger)
    end
  end

  def info(str)
    @logger_array.each  do |log|
      log.info(str)
    end
  end

  def warn(str)
    @logger_array.each  do |log|
      log.warn(str)
    end
  end

  def error(str)
    @logger_array.each do |log|
      log.error(str)
    end
  end

  def fatal(str)
    @logger_array.each do |log|
      log.fatal(str)
    end
  end
end