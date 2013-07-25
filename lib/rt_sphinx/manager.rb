# encoding: utf-8

module RtSphinx
  class Manager
    def self.start
      kill_daemon_if_needed
      puts `searchd`
    end

    def self.kill_daemon_if_needed
      `pid=$(lsof -i :9327 -t); if [ $pid ] ; then kill -TERM $pid || kill -KILL $pid; fi;`
      sleep(1)
    end

    # TODO: create configurator method. Template should be like this:
    # <<INDEX_TEMPLATE
    # index #{config.index} {
    #   type = rt
    #   ...
    # }
    # INDEX_TEMPLATE
  end
end
