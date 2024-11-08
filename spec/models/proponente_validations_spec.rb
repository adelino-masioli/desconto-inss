require 'rails_helper'

RSpec.describe Proponente, type: :model do
  let(:valid_attributes) { FactoryBot.attributes_for(:proponente) }

  context "when required attributes are missing" do
    it "is invalid without a nome" do
      proponente = Proponente.new(valid_attributes.merge(nome: nil))
      proponente.valid?
      expect(proponente.errors[:nome]).to include("não pode ficar em branco")
    end

    it "is invalid without a cpf" do
      proponente = Proponente.new(valid_attributes.merge(cpf: nil))
      proponente.valid?
      expect(proponente.errors[:cpf]).to include("não pode ficar em branco")
    end

    it "is invalid without a data_nascimento" do
      proponente = Proponente.new(valid_attributes.merge(data_nascimento: nil))
      proponente.valid?
      expect(proponente.errors[:data_nascimento]).to include("não pode ficar em branco")
    end

    it "is invalid without a logradouro" do
      proponente = Proponente.new(valid_attributes.merge(logradouro: nil))
      proponente.valid?
      expect(proponente.errors[:logradouro]).to include("não pode ficar em branco")
    end

    # Adicione outros testes de validação conforme necessário
  end
end
