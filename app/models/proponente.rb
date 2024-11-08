class Proponente < ApplicationRecord
  # Constantes para as faixas salariais
  FAIXAS_SALARIAIS = [
    { limite: 1_045.00, aliquota: 0.075 },
    { limite: 2_089.60, aliquota: 0.09 },
    { limite: 3_134.40, aliquota: 0.12 },
    { limite: 6_101.06, aliquota: 0.14 }
  ].freeze

  # Validações
  validates :nome, presence: true, length: { in: 2..100 }
  validates :cpf, presence: true, uniqueness: true
  validates :data_nascimento, presence: true
  validates :salario, presence: true, numericality: { greater_than: 0 }
  validates :logradouro, :numero, :bairro, :cidade, :estado, :cep, presence: true
  validate :data_nascimento_valida

  # Serialização do campo telefones
  serialize :telefones, HashSerializer

  # Callbacks
  before_save :atualizar_desconto_inss, if: :salario_changed?

  # Delegações para telefones
  delegate :pessoal, :referencia, to: :telefones, prefix: :telefone, allow_nil: true

  # Scopes refinados
  FAIXAS_SALARIAIS.each_with_index do |faixa, index|
    # Criamos o escopo de cada faixa salarial, com limite inferior e superior
    scope "faixa#{index + 1}".to_sym, -> {
      faixa_anterior = FAIXAS_SALARIAIS[index - 1] if index > 0
      limite_inferior = faixa_anterior ? faixa_anterior[:limite] : 0
      where(salario: limite_inferior..faixa[:limite])
    }
  end

  class << self
    # Calcula o desconto INSS conforme o salário
    def calcular_desconto_inss(salario)
      return 0 if salario <= 0

      desconto = 0.0
      faixa_anterior = 0

      FAIXAS_SALARIAIS.each do |faixa|
        break if salario <= faixa_anterior

        valor_base = [salario, faixa[:limite]].min - faixa_anterior
        desconto += valor_base * faixa[:aliquota]
        faixa_anterior = faixa[:limite]
      end

      desconto.round(2)
    end

    # Relatório de faixas salariais
    def relatorio_faixas_salariais
      FAIXAS_SALARIAIS.each_with_index.to_h do |faixa, index|
        ["faixa#{index + 1}".to_sym, send("faixa#{index + 1}").count]
      end
    end
  end

  private

  # Atualiza o desconto INSS do funcionário
  def atualizar_desconto_inss
    self.desconto_inss = self.class.calcular_desconto_inss(salario)
  end

  # Valida se a data de nascimento não é no futuro
  def data_nascimento_valida
    return unless data_nascimento.present? && data_nascimento > Date.current

    errors.add(:data_nascimento, 'não pode ser uma data futura')
  end
end
