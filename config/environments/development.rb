require "active_support/core_ext/integer/time"

Rails.application.configure do
  # As configurações especificadas aqui terão precedência sobre as definidas em config/application.rb.

  # No ambiente de desenvolvimento, o código da aplicação é recarregado sempre que há alterações.
  # Isso pode reduzir a performance, mas é ideal para o desenvolvimento, pois não é necessário reiniciar o servidor
  # toda vez que há modificações no código.
  config.cache_classes = false

  # Não carregar o código de forma ansiosa ao iniciar a aplicação.
  config.eager_load = false

  # Exibir relatórios de erro completos.
  config.consider_all_requests_local = true

  # Habilitar a medição de tempo do servidor.
  config.server_timing = true

  # Habilitar/desabilitar cache. Por padrão, o cache está desabilitado.
  # Execute rails dev:cache para alternar o cache.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    # Quando o arquivo de cache existe, o caching é ativado.
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    # Usar o cache em memória.
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}" # Configuração para cache público.
    }
  else
    # Quando o arquivo de cache não existe, o caching é desabilitado.
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # Armazenar arquivos carregados no sistema de arquivos local (consulte config/storage.yml para opções).
  config.active_storage.service = :local

  # Não se importar se o mailer não puder enviar emails.
  config.action_mailer.raise_delivery_errors = false

  # Desabilitar cache no mailer.
  config.action_mailer.perform_caching = false

  # Imprimir avisos de descontinuação no log do Rails.
  config.active_support.deprecation = :log

  # Levantar exceções para descontinuações proibidas.
  config.active_support.disallowed_deprecation = :raise

  # Especificar quais mensagens de descontinuação são proibidas.
  config.active_support.disallowed_deprecation_warnings = []

  # Levantar um erro na carga da página se houver migrações pendentes.
  config.active_record.migration_error = :page_load

  # Destacar no log as consultas ao banco de dados que foram feitas.
  config.active_record.verbose_query_logs = true

  # Suprimir a saída do log para requisições de assets (arquivos estáticos).
  config.assets.quiet = true

  # Levantar erro em caso de traduções ausentes.
  # config.i18n.raise_on_missing_translations = true

  # Anotar as views renderizadas com os nomes dos arquivos.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Descomente se desejar permitir o acesso do Action Cable a partir de qualquer origem.
  # config.action_cable.disable_request_forgery_protection = true

  # Configuração do ActionMailer para usar o Mailtrap
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp.mailtrap.io', # Endereço do servidor SMTP do Mailtrap
    port: 587, # Porta usada para a conexão SMTP
    user_name: ENV['MAILTRAP_USERNAME'], # Acessa a variável do .env para o nome de usuário
    password: ENV['MAILTRAP_PASSWORD'], # Acessa a variável do .env para a senha
    authentication: 'plain', # Autenticação no formato 'plain'
    enable_starttls_auto: true # Habilita o STARTTLS automaticamente para a conexão segura
  }
end
