# encoding utf-8

require 'java'

class HiveError < RuntimeError
end

class Hive
  
  # @private
  def self.bootstrap
    
    if ENV['HIVE_HOME']
      hive_home=ENV['HIVE_HOME']
    else
      raise HiveError, "HIVE_HOME is not set!"
    end
    hadoop_home=ENV['HADOOP_HOME']
    Dir[
        "#{hadoop_home}/share/hadoop/mapreduce/*.jar",
        "#{hadoop_home}/share/hadoop/mapreduce/lib/*.jar",
        "#{hive_home}/lib/*.jar"
    ].each do |jar|
      require jar
    end

    $CLASSPATH << "#{hive_home}/conf"
    require 'hdfs_jruby'

    java_import 'java.util.ArrayList'
    java_import 'org.apache.hadoop.hive.conf.HiveConf'
    #java_import 'org.apache.hadoop.hive.conf.HiveConf.ConfVars'                                                                              
    java_import 'org.apache.hadoop.hive.ql.Driver'
    java_import 'org.apache.hadoop.hive.ql.processors.CommandProcessorResponse'
    java_import 'org.apache.hadoop.hive.cli.CliSessionState'
    java_import 'org.apache.hadoop.hive.ql.session.SessionState'
    
  end
  
  # @param [String] db dbname
  def initialize(db="default")
    @db = db
    @hconf = HiveConf.new
    
    @driver = Driver.new(@hconf)
    SessionState.start(CliSessionState.new(@hconf))
    @driver.run("use #{@db}")
  end

  # @param [String] db dbname
  def use(db)
    @db = db
    @driver.run("use #{@db}")
  end
  
  # run query
  # @example
  #   hive = Hive.new()
  #   hive.run("select * from hoge").each do | row |
  #     p row
  #   end
  # @param [String] cmd HQL query
  # @return [Array] result row array
  def run(cmd, max_rows=10000)
    @driver.setMaxRows(max_rows)
    r = @driver.run(cmd)
    if r.getResponseCode != 0
      raise HiveError, "hive error: " << r.getErrorMessage
    end
    if block_given?
      list = ArrayList.new
      while @driver.getResults(list)
        list.each do | n |
          yield n
        end
        list.clear
      end
    else
      list = ArrayList.new
      if @driver.getResults(list)
        return list.to_ary
      end
      return nil
    end
  end
  
end

Hive.bootstrap
