require "fileutils"
require "json"

ASSET_DIR = "assets"
BOWERCONFIG = ".bowerrc"
BOWERJSON = "bower.json"
DEFAULT_DIR = "bower_components"

class Bower_helper
  # Finds where bower components are being installed.
  # # This can either be the default bower_components
  # # or a directory defined in .bowerrc
  def bower_dir
    if(File.exist?(BOWERCONFIG))
      rcFile = JSON.parse(File.read(BOWERCONFIG))
      return rcFile["directory"] || DEFAULT_DIR
    else
      return DEFAULT_DIR
    end
  end

  # given a dependancies dir 'dir', analyze its bower.json
  # from that file get its 'main' file and the dependancies name
  def extract_dependancy(component)
    bower_file = File.join(component, BOWERJSON)

    if(!File.exist?(bower_file))
      logger.warn "no #{BOWERJSON} file found for #{component}"
      return
    end

    bower_file = JSON.parse(File.read(bower_file))
    if(!bower_file.has_key?('main'))
      logger.warn "No main section found for #{component}"
      return
    end

    files_ = bower_file['main']
    files = files_.is_a?(Array) ? files_ : [files_]

    {
      :name => bower_file['name'],
      :files => files
    }
  end

end

bower_dir = Bower_helper.new().bower_dir
component_search = File.join(bower_dir,"*")

packages = Dir.glob(component_search).select{|c| File.directory? c}.map { |component|
  Bower_helper.new().extract_dependancy component
}

packages.each do |package|
  package_name = package[:name]
  package_dest = File.join(ASSET_DIR, package_name)

  package[:files].each do |filepath|
    file_dest = File.join(package_dest, File.dirname(filepath))
    file_src = File.join(bower_dir, package_name, filepath)

    if(!Dir.exist?(file_dest))
      FileUtils.mkdir_p(file_dest)
    end

    FileUtils.cp(file_src, file_dest)
  end
end
