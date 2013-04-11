namespace :jekyll do
  desc "A very naive invocation of 'jekyll build'"
  task :build => :environment do
    options = Jekyll.configuration({ :serving => false })
    Jekyll::Commands::Build.process(options)
  end
end
task 'assets:precompile' => 'jekyll:build'