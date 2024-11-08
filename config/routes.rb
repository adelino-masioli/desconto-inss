# config/routes.rb

require 'sidekiq/web' # Necessário para o painel do Sidekiq

Rails.application.routes.draw do
  devise_for :users
  # Proteja a rota do painel do Sidekiq (opcional, mas recomendado)
  if Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  end

  # Rota principal
  root "proponentes#index"  # A página inicial pode ser a lista de proponentes, por exemplo

  # Rotas para Proponentes
  resources :proponentes do
    collection do
      # Rota personalizada para o cálculo de desconto
      get :calcular_inss

      # Rota personalizada para o relatório de faixas salariais
      get :relatorio
    end
  end
end
