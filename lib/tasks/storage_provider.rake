require 'faker'
require 'factory_girl_rails'
namespace :storage_provider do
  desc "creates a storage_provider using ENV[SWIFT_ACCT,SWIFT_URL_ROOT,SWIFT_VERSION,SWIFT_AUTH_URI,SWIFT_USER,SWIFT_PASS,SWIFT_PRIMARY_KEY,SWIFT_SECONDARY_KEY]"
  task create: :environment do
    unless ENV['SWIFT_ACCT']
      $stderr.puts "YOU DO NOT HAVE YOUR SWIFT ENVIRONMENT VARIABLES SET"
      exit
    end
    unless StorageProvider.where(name: ENV['SWIFT_ACCT']).exists?
      FactoryGirl.create(:storage_provider, :swift_env)
    end
  end

  desc "destroys the storage_provider defined for ENV[SWIFT_ACCT]"
  task destroy: :environment do
    storage_provider = StorageProvider.where(name: ENV['SWIFT_ACCT']).first
    if storage_provider
      storage_provider.destroy
    end
  end
end