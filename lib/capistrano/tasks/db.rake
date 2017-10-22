require File.expand_path("#{File.dirname(__FILE__)}/database")

namespace :db do

  namespace :sync do

    desc <<-DESC
    Push the current local development database to the remote database from the selected stage 
    environment. The database credentials will be read from the remote config/database.yml file.
    DESC
    task :local_to_remote do

      on roles(:all) do
        # Backup de la base donnée distante

        # Création du répertoire de synchronisation
        execute :mkdir, "-p #{shared_path}/sync"

        # Création du fichier SQL de la base de données locale
        filename = "dump.local.#{Time.now.strftime '%Y-%m-%d_%H-%M-%S'}.sql"
        username, password, database, host = database_config('development')
        system "mysqldump -u #{username} --password=#{password} #{database} > #{filename}"

        # Export du fichier SQL
        upload! filename, "#{shared_path}/sync/#{filename}"

        # Suppression du fichier SQL de la base de données locale
        system "rm -f #{filename}"

        # Import de la base de données
        username, password, database, host = remote_database_config(:stage)
        hostcmd = host.nil? ? '' : "-h #{host}"
        execute :mysql, "-u #{username} --password=#{password} #{database} #{hostcmd} < #{shared_path}/sync/#{filename}"
      end

    end


    desc <<-DESC
    Retrieves a remote database from the selected stage environment to the local development
    environment. The database credentials will be read from your local config/database.yml file.
    DESC
    task :remote_to_local do
      on roles(:all) do
        # Backup de la base donnée distante

        # Création du fichier SQL de la base de données distante
        filename = "dump.local.#{Time.now.strftime '%Y-%m-%d_%H-%M-%S'}.sql"
        username, password, database, host = remote_database_config('stage')
        execute "mysqldump -u #{username} --password=#{password} #{database} > #{shared_path}/sync/#{filename}"

        # Import du fichier SQL
        download! "#{shared_path}/sync/#{filename}", filename

        # Import de la base de données
        username, password, database, host = remote_database_config(:stage)
        hostcmd = host.nil? ? '' : "-h #{host}"
        system "mysql -u #{username} --password=#{password} #{database} #{hostcmd} < #{filename}"

        # Suppression du fichier SQL de la base de données distante
        system "rm -f #{filename}"
      end
    end

  end

end

def database_config(db)
  database = YAML::load_file('config/database.yml')
  return database["#{db}"]['user'], database["#{db}"]['password'], database["#{db}"]['dbname'], database["#{db}"]['host']
end

def remote_database_config(db)
  remote_config = capture("cat #{shared_path}/config/database.yml")
  database = YAML::load(remote_config)
  return database["#{db}"]['user'], database["#{db}"]['password'], database["#{db}"]['dbname'], database["#{db}"]['host']
end

def purge_old_backups(base)
  count = fetch(:sync_backups, 5).to_i
  backup_files = capture("ls -xt #{shared_path}/sync/#{base}*").split.reverse
  if count >= backup_files.length
    logger.important "no old backups to clean up"
  else
    logger.info "keeping #{count} of #{backup_files.length} sync backups"
    delete_backups = (backup_files - backup_files.last(count)).join(" ")
    try_sudo "rm -rf #{delete_backups}"
  end
end