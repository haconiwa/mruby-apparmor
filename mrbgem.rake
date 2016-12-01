module AppArmor
  APPARMOR_VERSION = "2.10.95"
end

require 'fileutils'
require 'open3'

MRuby::Gem::Specification.new('mruby-apparmor') do |spec|
  spec.license = 'MIT'
  spec.authors = 'Uchio Kondo'
  #spec.version = AppArmor::VERSION

  def run_command env, command
    STDOUT.sync = true
    puts "EXEC\t[mruby-apparmor] #{command}"
    Open3.popen2e(env, command) do |stdin, stdout, thread|
      print stdout.read
      fail "#{command} failed" if thread.value != 0
    end
  end

  def spec.bundle_apparmor
    version = AppArmor::APPARMOR_VERSION
    tarball_url = "https://launchpad.net/apparmor/2.11/2.11.beta1/+download/apparmor-#{version}.tar.gz"

    def apparmor_dir(b); "#{b.build_dir}/vendor/apparmor"; end
    def libapparmor_dir(b); "#{apparmor_dir(b)}/libraries/libapparmor"; end
    def apparmor_objs_dir(b); "#{apparmor_dir(b)}/.objs"; end
    def apparmor_header(b); "#{libapparmor_dir(b)}/include/apparmor.h"; end
    def libapparmor_a(b); libfile "#{apparmor_objs_dir(b)}/lib/libapparmor"; end

    task :clean do
      FileUtils.rm_rf [apparmor_dir(build)]
    end

    file apparmor_header(build) do
      unless File.exist? libapparmor_dir(build)
        tmpdir = '/tmp'
        run_command ENV, "rm -rf #{tmpdir}/apparmor-#{version}"
        run_command ENV, "mkdir -p #{File.dirname(apparmor_dir(build))}"
        run_command ENV, "curl -L #{tarball_url} | tar -xz -f - -C #{tmpdir}"
        run_command ENV, "mv -f #{tmpdir}/apparmor-#{version} #{apparmor_dir(build)}"
      end
    end

    file libapparmor_a(build) => apparmor_header(build) do
      sh "mkdir -p #{apparmor_objs_dir(build)}"

      unless File.exist?(libapparmor_a(build))
        Dir.chdir libapparmor_dir(build) do
          run_command ENV, "test -f ./configure || sh ./autogen.sh"
          run_command ENV, "./configure --enable-static --disable-shared --prefix=#{apparmor_objs_dir(build)}"
          run_command ENV, "make"
          run_command ENV, "make install"
        end
      end
    end

    libmruby_a = libfile("#{build.build_dir}/lib/libmruby")
    file libmruby_a => libapparmor_a(build)

    self.cc.include_paths << File.dirname(apparmor_header(build))
    self.linker.library_paths << File.dirname(libapparmor_a(build))
    self.linker.libraries << 'apparmor'
  end

  spec.bundle_apparmor

  spec.add_test_dependency 'mruby-print'
end
