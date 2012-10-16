require 'guard'
require 'guard/guard'
require 'guard/watcher'

require 'uglifier'

module Guard
  class Uglify < Guard
    DEFAULT_OPTIONS = {
      :all_on_start => false
    }

    def initialize(watchers=[], options={})
      options.merge(DEFAULT_OPTIONS)
      super
      @input = options[:input]
      @output = options[:output]
      @extension = options[:extension] || "min"
    end

    def start
      run_all if options[:all_on_start]
    end

    def reload
      run_all
    end

    def run_all
      run_on_changes(Watcher.match_files(self, Dir.glob("#{@input}{,/*/**}/*.js")))
    end

    def run_on_changes(paths)
      uglify(paths)
    end

    def run_on_removals(paths)
      begin
        minpaths = paths.map{|f| f.split(".").insert(-2, @extension).join(".")}
        File.delete(*minpaths)
        UI.info "Removed #{minpaths.join(",")}"
        Notifier.notify "Removed #{minpaths.join(",")}"
      rescue => e
        UI.error "Failed to remove #{minpaths}: #{e}"
        Notifier.notify "Failed to remove #{minpaths}: #{e}"
        return false
      end
      true
    end

    private
    def uglify(paths)
      paths.each do |file|
        begin
          uglified = Uglifier.compile(File.read(file), :copyright => false)
          outdir = @output || File.dirname(file)
          outfile = File.join(outdir, File.basename(file).split(".").insert(-2, @extension).join("."))
          File.open(outfile,'w'){ |f| f.write(uglified) }
          UI.info         "Uglified #{file} to #{outfile}"
          Notifier.notify "Uglified #{file} to #{outfile}", :title => 'Uglify'
        rescue Exception => e
          UI.error        "Uglifying #{file} failed: #{e}"
          Notifier.notify "Uglifying #{file} failed: #{e}", :title => 'Uglify', :image => :failed
          return false
        end
      end
      true
    end
  end
end
