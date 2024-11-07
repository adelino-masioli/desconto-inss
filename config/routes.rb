# config/routes.rb

require 'sidekiq/web' # Necessário para o painel do Sidekiq

Rails.application.routes.draw do
  # Proteja a rota do painel do Sidekiq (opcional, mas recomendado)
  # authenticate :user, ->(user) { user.admin? } do # Exemplo com Devise e um admin check
  #   mount Sidekiq::Web => '/sidekiq'
  # end

  # Caso esteja em um ambiente de desenvolvimento ou queira deixar aberto, use:
  # mount Sidekiq::Web => '/sidekiq'

  if Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  end

  # Rota principal (exemplo)
  # root "home#index"

  # Outras rotas da sua aplicação aqui
end
