# encoding utf-8

class Hive

  def bootstrap
    require 'java'
    
    @JAR_PATTERN_0_20="hadoop-core-*.jar"

    if ENV["HADOOP_HOME"]
      hadoop_home=ENV["HADOOP_HOME"]
    else
      raise "hadoop_home is not set!"
    end
    
    if ENV['HIVE_HOME']
      hive_home=ENV['HIVE_HOME']
    else
      raise "HIVE_HOME is not set!"
    end
    
    Dir[
        "#{hadoop_home}/#{@JAR_PATTERN_0_20}",
        "#{hadoop_home}/lib/*.jar",
        "#{hadoop_home}/share/hadoop/common/*.jar",
        "#{hadoop_home}/share/hadoop/common/lib/*.jar",
        "#{hadoop_home}/share/hadoop/hdfs/*.jar",
        "#{hadoop_home}/share/hadoop/hdfs/lib/*.jar",
        "#{hadoop_home}/share/hadoop/mapreduce/*.jar",
        "#{hadoop_home}/share/hadoop/mapreduce/lib/*.jar",
        "#{hive_home}/lib/*.jar"
     ].each do |jar|
      require jar
    end
    
    $CLASSPATH << "#{hadoop_home}/conf"
    $CLASSPATH << "#{hive_home}/conf"
    
    java_import 'java.util.ArrayList'
    java_import 'org.apache.hadoop.hive.conf.HiveConf'
    #java_import 'org.apache.hadoop.hive.conf.HiveConf.ConfVars'
    java_import 'org.apache.hadoop.hive.ql.Driver'
    java_import 'org.apache.hadoop.hive.ql.processors.CommandProcessorResponse'
    java_import 'org.apache.hadoop.hive.cli.CliSessionState'
    java_import 'org.apache.hadoop.hive.ql.session.SessionState'
  end
  
  def initialize
    self.bootstrap
    
    @hconf = HiveConf.new
    
    @driver = Driver.new(@hconf)
    SessionState.start(CliSessionState.new(@hconf))
  end
  
  def run(cmd)
    r = @driver.run(cmd)
    if r.getResponseCode != 0
      raise "hive error: " << r.getErrorMessage
    end
    
    list = ArrayList.new
    if @driver.getResults(list)
      return list.to_ary
    end
    return nil
  end
  
end
