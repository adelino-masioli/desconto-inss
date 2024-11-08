# Desconto INSS - Aplicação Rails

## Desafio

Este projeto foi desenvolvido como parte de um desafio técnico, com o objetivo de criar uma aplicação "Desconto INSS" utilizando o framework **Rails 5+** com PostgreSQL, Bootstrap, Chart.js, Rubocop Rails, Kaminari, Redis e Sidekiq.

### Tecnologias Utilizadas:

- **Rails 5+**
- **PostgreSQL**
- **Bootstrap**
- **Chart.js**
- **Rubocop Rails**
- **Kaminari** (Paginação)
- **Redis** (para gerenciamento de tarefas)
- **Sidekiq** (para processamento assíncrono)

---

## Funcionalidades

### 1. Cadastro de Proponente (CRUD)

O sistema permite o cadastro de proponentes com as seguintes informações:

- **Nome**
- **CPF**
- **Data de nascimento**
- **Endereço** (logradouro, número, bairro, cidade, estado, CEP)
- **Telefones para contato** (pessoais e referências)
- **Salário**

A listagem dos proponentes usa **paginação**, exibindo apenas 5 resultados por página.

---

### 2. Cálculo de Desconto de INSS

No formulário de cadastro de proponentes, ao informar o valor do salário, o sistema realiza uma requisição **ajax (XHR)** para calcular o desconto do INSS, baseado na tabela vigente para 2020:

| Faixa Salarial                 | Alíquota |
| ------------------------------ | -------- |
| Até R$ 1.045,00                | 7,5%     |
| De R$ 1.045,01 a R$ 2.089,60   | 9%       |
| De R$ 2.089,61 até R$ 3.134,40 | 12%      |
| De R$ 3.134,41 até R$ 6.101,06 | 14%      |

Exemplo de cálculo para um salário de R$ 3.000,00:

- **Primeira faixa**: R$ 1.045,00 x 7,5% = R$ 78,37
- **Segunda faixa**: (R$ 2.089,60 - R$ 1.045,00) x 9% = R$ 94,01
- **Terceira faixa**: (R$ 3.000,00 - R$ 2.089,60) x 12% = R$ 109,24
- **Total**: R$ 78,37 + R$ 94,01 + R$ 109,24 = R$ 281,62

O valor do desconto é exibido no formulário e registrado no cadastro.

---

### 3. Relatório dos Funcionários

É gerado um relatório para exibir os proponentes agrupados por faixas salariais, mostrando o número de funcionários em cada faixa, conforme as seguintes categorias:

- **Até R$ 1.045,00**
- **De R$ 1.045,01 a R$ 2.089,60**
- **De R$ 2.089,61 até R$ 3.134,40**
- **De R$ 3.134,41 até R$ 6.101,06**

O relatório exibe os dados tanto em formato de lista quanto em gráfico (utilizando **Chart.js**).

---

## Requisitos

- Iniciar com pelo menos **10 registros (seed)**.
- Atualizar salário do funcionário utilizando **mensagens/jobs com Redis e Sidekiq**.
- Padronizar o código com **Rubocop Rails**.
- Utilizar **TDD (Test-Driven Development)** para garantir a qualidade do código.
- Dockerização da aplicação para facilitar a execução e portabilidade.

---

## Configuração e Execução

### 1. Dockerização

A aplicação está configurada para rodar dentro de um container Docker. Para iniciar a aplicação, execute os seguintes comandos:

```bash
docker-compose up
docker-compose restart web

docker-compose exec web rails assets:clobber
docker-compose exec web rails assets:precompile

docker-compose exec web bundle rspec
docker-compose exec web bundle exec rspec spec/models/proponente_spec.rb

rubocop --auto-correct


docker-compose exec web rails db:migrate
docker-compose exec web rails db:seed

```

Desenvolvido por Adelino Masioli.
