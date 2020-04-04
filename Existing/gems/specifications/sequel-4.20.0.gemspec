# -*- encoding: utf-8 -*-
# stub: sequel 4.20.0 ruby lib

Gem::Specification.new do |s|
  s.name = "sequel".freeze
  s.version = "4.20.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jeremy Evans".freeze]
  s.date = "2015-03-03"
  s.description = "The Database Toolkit for Ruby".freeze
  s.email = "code@jeremyevans.net".freeze
  s.executables = ["sequel".freeze]
  s.extra_rdoc_files = ["README.rdoc".freeze, "CHANGELOG".freeze, "MIT-LICENSE".freeze, "doc/active_record.rdoc".freeze, "doc/advanced_associations.rdoc".freeze, "doc/association_basics.rdoc".freeze, "doc/cheat_sheet.rdoc".freeze, "doc/dataset_basics.rdoc".freeze, "doc/dataset_filtering.rdoc".freeze, "doc/migration.rdoc".freeze, "doc/model_hooks.rdoc".freeze, "doc/opening_databases.rdoc".freeze, "doc/prepared_statements.rdoc".freeze, "doc/querying.rdoc".freeze, "doc/reflection.rdoc".freeze, "doc/sharding.rdoc".freeze, "doc/sql.rdoc".freeze, "doc/validations.rdoc".freeze, "doc/virtual_rows.rdoc".freeze, "doc/mass_assignment.rdoc".freeze, "doc/testing.rdoc".freeze, "doc/schema_modification.rdoc".freeze, "doc/transactions.rdoc".freeze, "doc/thread_safety.rdoc".freeze, "doc/object_model.rdoc".freeze, "doc/core_extensions.rdoc".freeze, "doc/bin_sequel.rdoc".freeze, "doc/security.rdoc".freeze, "doc/postgresql.rdoc".freeze, "doc/code_order.rdoc".freeze, "doc/model_plugins.rdoc".freeze, "doc/extensions.rdoc".freeze, "doc/mssql_stored_procedures.rdoc".freeze, "doc/release_notes/1.0.txt".freeze, "doc/release_notes/1.1.txt".freeze, "doc/release_notes/1.3.txt".freeze, "doc/release_notes/1.4.0.txt".freeze, "doc/release_notes/1.5.0.txt".freeze, "doc/release_notes/2.0.0.txt".freeze, "doc/release_notes/2.1.0.txt".freeze, "doc/release_notes/2.10.0.txt".freeze, "doc/release_notes/2.11.0.txt".freeze, "doc/release_notes/2.12.0.txt".freeze, "doc/release_notes/2.2.0.txt".freeze, "doc/release_notes/2.3.0.txt".freeze, "doc/release_notes/2.4.0.txt".freeze, "doc/release_notes/2.5.0.txt".freeze, "doc/release_notes/2.6.0.txt".freeze, "doc/release_notes/2.7.0.txt".freeze, "doc/release_notes/2.8.0.txt".freeze, "doc/release_notes/2.9.0.txt".freeze, "doc/release_notes/3.0.0.txt".freeze, "doc/release_notes/3.1.0.txt".freeze, "doc/release_notes/3.10.0.txt".freeze, "doc/release_notes/3.11.0.txt".freeze, "doc/release_notes/3.12.0.txt".freeze, "doc/release_notes/3.13.0.txt".freeze, "doc/release_notes/3.14.0.txt".freeze, "doc/release_notes/3.15.0.txt".freeze, "doc/release_notes/3.16.0.txt".freeze, "doc/release_notes/3.17.0.txt".freeze, "doc/release_notes/3.18.0.txt".freeze, "doc/release_notes/3.19.0.txt".freeze, "doc/release_notes/3.2.0.txt".freeze, "doc/release_notes/3.20.0.txt".freeze, "doc/release_notes/3.21.0.txt".freeze, "doc/release_notes/3.22.0.txt".freeze, "doc/release_notes/3.23.0.txt".freeze, "doc/release_notes/3.24.0.txt".freeze, "doc/release_notes/3.25.0.txt".freeze, "doc/release_notes/3.3.0.txt".freeze, "doc/release_notes/3.4.0.txt".freeze, "doc/release_notes/3.5.0.txt".freeze, "doc/release_notes/3.6.0.txt".freeze, "doc/release_notes/3.7.0.txt".freeze, "doc/release_notes/3.8.0.txt".freeze, "doc/release_notes/3.9.0.txt".freeze, "doc/release_notes/3.26.0.txt".freeze, "doc/release_notes/3.27.0.txt".freeze, "doc/release_notes/3.28.0.txt".freeze, "doc/release_notes/3.29.0.txt".freeze, "doc/release_notes/3.30.0.txt".freeze, "doc/release_notes/3.31.0.txt".freeze, "doc/release_notes/3.32.0.txt".freeze, "doc/release_notes/3.33.0.txt".freeze, "doc/release_notes/3.34.0.txt".freeze, "doc/release_notes/3.35.0.txt".freeze, "doc/release_notes/3.36.0.txt".freeze, "doc/release_notes/3.37.0.txt".freeze, "doc/release_notes/3.38.0.txt".freeze, "doc/release_notes/3.39.0.txt".freeze, "doc/release_notes/3.40.0.txt".freeze, "doc/release_notes/3.41.0.txt".freeze, "doc/release_notes/3.42.0.txt".freeze, "doc/release_notes/3.43.0.txt".freeze, "doc/release_notes/3.44.0.txt".freeze, "doc/release_notes/3.45.0.txt".freeze, "doc/release_notes/3.46.0.txt".freeze, "doc/release_notes/3.47.0.txt".freeze, "doc/release_notes/3.48.0.txt".freeze, "doc/release_notes/4.0.0.txt".freeze, "doc/release_notes/4.1.0.txt".freeze, "doc/release_notes/4.2.0.txt".freeze, "doc/release_notes/4.3.0.txt".freeze, "doc/release_notes/4.4.0.txt".freeze, "doc/release_notes/4.5.0.txt".freeze, "doc/release_notes/4.6.0.txt".freeze, "doc/release_notes/4.7.0.txt".freeze, "doc/release_notes/4.8.0.txt".freeze, "doc/release_notes/4.9.0.txt".freeze, "doc/release_notes/4.10.0.txt".freeze, "doc/release_notes/4.11.0.txt".freeze, "doc/release_notes/4.12.0.txt".freeze, "doc/release_notes/4.13.0.txt".freeze, "doc/release_notes/4.14.0.txt".freeze, "doc/release_notes/4.15.0.txt".freeze, "doc/release_notes/4.16.0.txt".freeze, "doc/release_notes/4.17.0.txt".freeze, "doc/release_notes/4.18.0.txt".freeze, "doc/release_notes/4.19.0.txt".freeze, "doc/release_notes/4.20.0.txt".freeze]
  s.files = ["CHANGELOG".freeze, "MIT-LICENSE".freeze, "README.rdoc".freeze, "bin/sequel".freeze, "doc/active_record.rdoc".freeze, "doc/advanced_associations.rdoc".freeze, "doc/association_basics.rdoc".freeze, "doc/bin_sequel.rdoc".freeze, "doc/cheat_sheet.rdoc".freeze, "doc/code_order.rdoc".freeze, "doc/core_extensions.rdoc".freeze, "doc/dataset_basics.rdoc".freeze, "doc/dataset_filtering.rdoc".freeze, "doc/extensions.rdoc".freeze, "doc/mass_assignment.rdoc".freeze, "doc/migration.rdoc".freeze, "doc/model_hooks.rdoc".freeze, "doc/model_plugins.rdoc".freeze, "doc/mssql_stored_procedures.rdoc".freeze, "doc/object_model.rdoc".freeze, "doc/opening_databases.rdoc".freeze, "doc/postgresql.rdoc".freeze, "doc/prepared_statements.rdoc".freeze, "doc/querying.rdoc".freeze, "doc/reflection.rdoc".freeze, "doc/release_notes/1.0.txt".freeze, "doc/release_notes/1.1.txt".freeze, "doc/release_notes/1.3.txt".freeze, "doc/release_notes/1.4.0.txt".freeze, "doc/release_notes/1.5.0.txt".freeze, "doc/release_notes/2.0.0.txt".freeze, "doc/release_notes/2.1.0.txt".freeze, "doc/release_notes/2.10.0.txt".freeze, "doc/release_notes/2.11.0.txt".freeze, "doc/release_notes/2.12.0.txt".freeze, "doc/release_notes/2.2.0.txt".freeze, "doc/release_notes/2.3.0.txt".freeze, "doc/release_notes/2.4.0.txt".freeze, "doc/release_notes/2.5.0.txt".freeze, "doc/release_notes/2.6.0.txt".freeze, "doc/release_notes/2.7.0.txt".freeze, "doc/release_notes/2.8.0.txt".freeze, "doc/release_notes/2.9.0.txt".freeze, "doc/release_notes/3.0.0.txt".freeze, "doc/release_notes/3.1.0.txt".freeze, "doc/release_notes/3.10.0.txt".freeze, "doc/release_notes/3.11.0.txt".freeze, "doc/release_notes/3.12.0.txt".freeze, "doc/release_notes/3.13.0.txt".freeze, "doc/release_notes/3.14.0.txt".freeze, "doc/release_notes/3.15.0.txt".freeze, "doc/release_notes/3.16.0.txt".freeze, "doc/release_notes/3.17.0.txt".freeze, "doc/release_notes/3.18.0.txt".freeze, "doc/release_notes/3.19.0.txt".freeze, "doc/release_notes/3.2.0.txt".freeze, "doc/release_notes/3.20.0.txt".freeze, "doc/release_notes/3.21.0.txt".freeze, "doc/release_notes/3.22.0.txt".freeze, "doc/release_notes/3.23.0.txt".freeze, "doc/release_notes/3.24.0.txt".freeze, "doc/release_notes/3.25.0.txt".freeze, "doc/release_notes/3.26.0.txt".freeze, "doc/release_notes/3.27.0.txt".freeze, "doc/release_notes/3.28.0.txt".freeze, "doc/release_notes/3.29.0.txt".freeze, "doc/release_notes/3.3.0.txt".freeze, "doc/release_notes/3.30.0.txt".freeze, "doc/release_notes/3.31.0.txt".freeze, "doc/release_notes/3.32.0.txt".freeze, "doc/release_notes/3.33.0.txt".freeze, "doc/release_notes/3.34.0.txt".freeze, "doc/release_notes/3.35.0.txt".freeze, "doc/release_notes/3.36.0.txt".freeze, "doc/release_notes/3.37.0.txt".freeze, "doc/release_notes/3.38.0.txt".freeze, "doc/release_notes/3.39.0.txt".freeze, "doc/release_notes/3.4.0.txt".freeze, "doc/release_notes/3.40.0.txt".freeze, "doc/release_notes/3.41.0.txt".freeze, "doc/release_notes/3.42.0.txt".freeze, "doc/release_notes/3.43.0.txt".freeze, "doc/release_notes/3.44.0.txt".freeze, "doc/release_notes/3.45.0.txt".freeze, "doc/release_notes/3.46.0.txt".freeze, "doc/release_notes/3.47.0.txt".freeze, "doc/release_notes/3.48.0.txt".freeze, "doc/release_notes/3.5.0.txt".freeze, "doc/release_notes/3.6.0.txt".freeze, "doc/release_notes/3.7.0.txt".freeze, "doc/release_notes/3.8.0.txt".freeze, "doc/release_notes/3.9.0.txt".freeze, "doc/release_notes/4.0.0.txt".freeze, "doc/release_notes/4.1.0.txt".freeze, "doc/release_notes/4.10.0.txt".freeze, "doc/release_notes/4.11.0.txt".freeze, "doc/release_notes/4.12.0.txt".freeze, "doc/release_notes/4.13.0.txt".freeze, "doc/release_notes/4.14.0.txt".freeze, "doc/release_notes/4.15.0.txt".freeze, "doc/release_notes/4.16.0.txt".freeze, "doc/release_notes/4.17.0.txt".freeze, "doc/release_notes/4.18.0.txt".freeze, "doc/release_notes/4.19.0.txt".freeze, "doc/release_notes/4.2.0.txt".freeze, "doc/release_notes/4.20.0.txt".freeze, "doc/release_notes/4.3.0.txt".freeze, "doc/release_notes/4.4.0.txt".freeze, "doc/release_notes/4.5.0.txt".freeze, "doc/release_notes/4.6.0.txt".freeze, "doc/release_notes/4.7.0.txt".freeze, "doc/release_notes/4.8.0.txt".freeze, "doc/release_notes/4.9.0.txt".freeze, "doc/schema_modification.rdoc".freeze, "doc/security.rdoc".freeze, "doc/sharding.rdoc".freeze, "doc/sql.rdoc".freeze, "doc/testing.rdoc".freeze, "doc/thread_safety.rdoc".freeze, "doc/transactions.rdoc".freeze, "doc/validations.rdoc".freeze, "doc/virtual_rows.rdoc".freeze]
  s.homepage = "http://sequel.jeremyevans.net".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--quiet".freeze, "--line-numbers".freeze, "--inline-source".freeze, "--title".freeze, "Sequel: The Database Toolkit for Ruby".freeze, "--main".freeze, "README.rdoc".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7".freeze)
  s.rubygems_version = "2.6.14.1".freeze
  s.summary = "The Database Toolkit for Ruby".freeze

  s.installed_by_version = "2.6.14.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<tzinfo>.freeze, [">= 0"])
      s.add_development_dependency(%q<activemodel>.freeze, [">= 0"])
      s.add_development_dependency(%q<nokogiri>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<tzinfo>.freeze, [">= 0"])
      s.add_dependency(%q<activemodel>.freeze, [">= 0"])
      s.add_dependency(%q<nokogiri>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<tzinfo>.freeze, [">= 0"])
    s.add_dependency(%q<activemodel>.freeze, [">= 0"])
    s.add_dependency(%q<nokogiri>.freeze, [">= 0"])
  end
end
