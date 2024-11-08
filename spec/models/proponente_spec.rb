require 'rails_helper'

RSpec.describe Proponente, type: :model do
  let(:valid_attributes) do
    {
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
    }
  end

  it "is valid with valid attributes" do
    proponente = Proponente.new(valid_attributes)
    expect(proponente).to be_valid
  end
end
