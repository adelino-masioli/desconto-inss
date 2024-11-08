class Proponente < ApplicationRecord
  # Constantes para as faixas salariais
  FAIXAS_SALARIAIS = [
    { limite: 1_045.00, aliquota: 0.075 },
    { limite: 2_089.60, aliquota: 0.09 },
    { limite: 3_134.40, aliquota: 0.12 },
    { limite: 6_101.06, aliquota: 0.14 }
  ].freeze

  # Validações
  validates :nome, presence: true, length: { minimum: 2, maximum: 100 }
  validates :cpf, presence: true, uniqueness: true, cpf: true
  validates :data_nascimento, presence: true
  validates :salario, presence: true, numericality: { greater_than: 0 }
  validates :logradouro, :numero, :bairro, :cidade, :estado, :cep, presence: true
  validate :data_nascimento_valida

  # Serialização do campo telefones
  serialize :telefones, HashSerializer

  # Callbacks
  before_save :calcular_e_atualizar_desconto_inss, if: :salario_changed?

  # Delegações para telefones
  delegate :pessoal, :referencia, to: :telefones, prefix: :telefone, allow_nil: true

  # Scopes refinados
  scope :por_faixa_salarial, ->(min, max) { where(salario: min..max) }
  scope :faixa1, -> { por_faixa_salarial(0, 1_045.00) }
  scope :faixa2, -> { por_faixa_salarial(1_045.01, 2_089.60) }
  scope :faixa3, -> { por_faixa_salarial(2_089.61, 3_134.40) }
  scope :faixa4, -> { por_faixa_salarial(3_134.41, 6_101.06) }

  class << self
    def calcular_desconto_inss(salario)
      return 0 unless salario.positive?

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

    def relatorio_faixas_salariais
      {
        faixa1: faixa1.count,
        faixa2: faixa2.count,
        faixa3: faixa3.count,
        faixa4: faixa4.count
      }
    end
  end

  private

  def calcular_e_atualizar_desconto_inss
    self.desconto_inss = self.class.calcular_desconto_inss(salario)
  end

  def data_nascimento_valida
    return unless data_nascimento.present? && data_nascimento > Date.current

    errors.add(:data_nascimento, 'não pode ser uma data futura')
  end
end