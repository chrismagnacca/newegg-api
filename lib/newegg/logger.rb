module Newegg
  
  def logger
    @logger ||= Logger.new('log')
  end
  
  File.open(File.expand_path(File.dirname(__FILE__) + "/../../log/newegg.log"), 'w+')
  logger = Log4r::Logger.new('log')
  logger.outputters << Log4r::Outputter.stdout
  logger.outputters << Log4r::FileOutputter.new('log', :filename =>  File.expand_path(File.dirname(__FILE__) + "/../../log/newegg.log"))
  logger.debug("logging started")
end