module Metropoli
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      class_option  :skip_demo,       :type => :boolean, :default => false
      class_option  :with_jq,         :type => :boolean, :default => false 
      
      source_root File.expand_path('../templates',__FILE__)
      
      def self.next_migration_number(path)
        @seconds = @seconds.nil? ? Time.now.sec : (@seconds.to_i + 1)
        @seconds = "0#{@seconds.to_s}" if @seconds < 10
        Time.now.utc.strftime("%Y%m%d%H%M") + @seconds.to_s
      end
      
      def generate_countries
        migration_template 'migrate/create_metropoli_countries.rb', 'db/migrate/create_metropoli_countries.rb'
      end
      
      def generate_states
        migration_template 'migrate/create_metropoli_states.rb', 'db/migrate/create_metropoli_states.rb'
      end
      
      def generate_cities
        migration_template 'migrate/create_metropoli_cities.rb', 'db/migrate/create_metropoli_cities.rb'
      end
      
      def generate_locale
        copy_file 'locales/en.yml', 'config/locales/metropoli.en.yml' 
      end
      
      def generate_initializer
        copy_file 'initializers/metropoli.rb', 'config/initializers/metropoli.rb' 
      end
      
      def generate_demo_seed
        unless options.skip_demo?
          copy_file 'csv/countries.csv', 'db/csv/countries.csv' 
          copy_file 'csv/states.csv', 'db/csv/states.csv' 
          copy_file 'csv/cities.csv', 'db/csv/cities.csv' 
        end
      end
      
      def generate_jquery_ui_javascript
        if options.with_jq?
          copy_file 'javascripts/metropoli.jquery.ui.js', 'public/javascripts/metropoli.jquery.ui.js'
        end
      end
      
      def generate_routes
        route 'metropoli_for :cities, :states, :countries'
      end
      
      def show_readme
        readme 'README'
      end 
      
    end
  end
end