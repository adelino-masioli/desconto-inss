# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'

10.times do
  Proponente.create!(
    nome: Faker::Name.name,
    cpf: Faker::IDNumber.brazilian_citizen_number(formatted: true),
    data_nascimento: Faker::Date.birthday(min_age: 18, max_age: 65),
    logradouro: Faker::Address.street_name,
    numero: Faker::Address.building_number,
    bairro: Faker::Address.community,
    cidade: Faker::Address.city,
    estado: Faker::Address.state_abbr,
    cep: Faker::Address.zip_code,
    telefones: {
      pessoal: Faker::PhoneNumber.cell_phone,
      referencia: Faker::PhoneNumber.phone_number
    },
    salario: Faker::Number.between(from: 1000.00, to: 10_000.00).round(2)
  )
end

puts "10 proponentes criados com sucesso!"
