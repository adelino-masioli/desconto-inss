require 'rails_helper'

RSpec.describe Proponente, type: :model do
  let(:valid_attributes) { FactoryBot.attributes_for(:proponente) }

  context "when CPF is invalid" do
    it "is invalid with an invalid CPF" do
      proponente = Proponente.new(valid_attributes.merge(cpf: "123.456.789-00"))
      proponente.valid?
      expect(proponente.errors[:cpf]).to include("não é válido")
    end
  end

  context "when generating CPF" do
    it "generates a valid CPF format" do
      proponente = Proponente.new(valid_attributes)
      expect(proponente.cpf).to match(/\d{3}\.\d{3}\.\d{3}-\d{2}/)
    end
  end
end
