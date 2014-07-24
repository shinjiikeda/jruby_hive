# encoding utf-8

class Hive

  def bootstrap
    include Java
    
    JAR_PATTERN_0_20="hadoop-core-*.jar"
    
    if ENV["HADOOP_HOME"]
      HADOOP_HOME=ENV["HADOOP_HOME"]
    else
      raise "HADOOP_HOME is not set!"
    end
    
    if ENV['HIVE_HOME']
      HIVE_HOME=ENV['HIVE_HOME']
    else
      raise "HIVE_HOME is not set!"
    end
    
    Dir[
        "#{HADOOP_HOME}/#{JAR_PATTERN_0_20}",
        "#{HADOOP_HOME}/lib/*.jar",
        "#{HADOOP_HOME}/share/hadoop/common/*.jar",
        "#{HADOOP_HOME}/share/hadoop/common/lib/*.jar",
        "#{HADOOP_HOME}/share/hadoop/hdfs/*.jar",
        "#{HADOOP_HOME}/share/hadoop/hdfs/lib/*.jar",
        "#{HADOOP_HOME}/share/hadoop/mapreduce/*.jar",
        "#{HADOOP_HOME}/share/hadoop/mapreduce/lib/*.jar",
        "#{HIVE_HOME}/lib/*.jar"
       ].each do |jar|
      require jar
    end
    
    $CLASSPATH << "#{HADOOP_HOME}/conf"
    $CLASSPATH << "#{HIVE_HOME}/conf"
    
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
    
    @driver = Driver.new(hconf)
    SessionState.start(CliSessionState.new(hconf))
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
