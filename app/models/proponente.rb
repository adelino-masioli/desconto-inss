class Proponente < ApplicationRecord
    validates :nome, presence: true
    validates :cpf, presence: true, uniqueness: true
    validates :salario, presence: true, numericality: { greater_than: 0 }
  
    # Método para calcular o desconto do INSS com base no salário
    def calcular_desconto_inss
      salario = self.salario
      descontos = [
        { limite: 1_045.00, aliquota: 0.075 },
        { limite: 2_089.60, aliquota: 0.09 },
        { limite: 3_134.40, aliquota: 0.12 },
        { limite: 6_101.06, aliquota: 0.14 }
      ]
  
      desconto = 0.0
      faixa_anterior = 0
  
      descontos.each do |faixa|
        if salario > faixa[:limite]
          # Calcula o valor da faixa e adiciona o desconto
          desconto += (faixa[:limite] - faixa_anterior) * faixa[:aliquota]
          faixa_anterior = faixa[:limite]
        else
          desconto += (salario - faixa_anterior) * faixa[:aliquota]
          break
        end
      end
  
      desconto
    end
  
    # Scopes para as faixas salariais
    scope :faixa1, -> { where(salario: 0..1_045) }
    scope :faixa2, -> { where(salario: 1_045.01..2_089.60) }
    scope :faixa3, -> { where(salario: 2_089.61..3_134.40) }
    scope :faixa4, -> { where(salario: 3_134.41..6_101.06) }
  
    # Relatório de quantidade de proponentes por faixa salarial
    def self.salarios_por_faixa
      {
        faixa1: faixa1.count,
        faixa2: faixa2.count,
        faixa3: faixa3.count,
        faixa4: faixa4.count
      }
    end
  end
  