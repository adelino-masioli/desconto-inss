# Use a imagem do Ruby como base
FROM ruby:3.2

# Instale dependências
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Configuração do diretório de trabalho
WORKDIR /app

# Copie o Gemfile e o Gemfile.lock para o container
COPY Gemfile* ./

# Instale as gems
RUN bundle install

# Copie o restante do código da aplicação
COPY . .

# Exponha a porta que o Rails usará
EXPOSE 3000

# Comando padrão para iniciar o servidor
CMD ["rails", "server", "-b", "0.0.0.0"]
