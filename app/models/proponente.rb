class Proponente < ApplicationRecord
  require 'cpf_cnpj'

  FAIXAS_SALARIAIS = [
    { limite: 1_045.00, aliquota: 0.075 },
    { limite: 2_089.60, aliquota: 0.09 },
    { limite: 3_134.40, aliquota: 0.12 },
    { limite: 6_101.06, aliquota: 0.14 }
  ].freeze

  validates :nome, presence: true, length: { in: 2..100 }
  validates :cpf, presence: true, uniqueness: true
  validate :cpf_valido
  validates :data_nascimento, presence: true
  validates :salario, presence: true, numericality: { greater_than: 0, message: 'deve ser maior que zero' }
  validates :logradouro, :numero, :bairro, :cidade, :estado, :cep, presence: true
  validate :data_nascimento_valida
  validate :validar_telefones_presence

  serialize :telefones, HashSerializer
  before_save :atualizar_desconto_inss

  delegate :pessoal, :referencia, to: :telefones, prefix: :telefone, allow_nil: true

  FAIXAS_SALARIAIS.each_with_index do |faixa, index|
    scope "faixa#{index + 1}".to_sym, lambda {
      faixa_anterior = FAIXAS_SALARIAIS[index - 1] if index.positive?
      limite_inferior = faixa_anterior ? faixa_anterior[:limite] : 0
      where(salario: limite_inferior..faixa[:limite])
    }
  end

  class << self
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

    def relatorio_faixas_salariais
      FAIXAS_SALARIAIS.each_with_index.to_h do |_faixa, index|
        ["faixa#{index + 1}".to_sym, send("faixa#{index + 1}").count]
      end
    end
  end

  private

  def atualizar_desconto_inss
    self.desconto_inss = self.class.calcular_desconto_inss(salario)
  end

  def data_nascimento_valida
    return unless data_nascimento.present? && data_nascimento > Date.current

    errors.add(:data_nascimento, 'não pode ser uma data futura')
  end

  def cpf_valido
    return if cpf.blank?

    cpf_sem_formatacao = cpf.gsub(/\D/, '') # Remove tudo que não for número
    return if CPF.valid?(cpf_sem_formatacao)

    errors.add(:cpf, 'não é válido')
  end

  def validar_telefones_presence
    # Inicializa telefones como um hash vazio se for nil
    self.telefones ||= {}

    # Verifica se o telefone 'pessoal' está presente
    errors.add(:telefones, 'pessoal não pode ficar em branco') if telefones['pessoal'].blank?

    # Verifica se o telefone 'referencia' está presente
    return unless telefones['referencia'].blank?

    errors.add(:telefones, 'referencia não pode ficar em branco')
    
  end
end
