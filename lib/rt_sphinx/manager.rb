# encoding: utf-8

module RtSphinx
  class Manager
    def self.start
      `killall searchd`
      sleep(1)
      res = `searchd`
      puts res
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
