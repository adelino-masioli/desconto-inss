# AtualizarSalarioJob: Job para atualizar o salário de um proponente no banco de dados.
# Este job é responsável por buscar o proponente pelo seu ID e realizar a atualização do salário,
# em uma transação, garantindo que a operação seja atômica.
class AtualizarSalarioJob < ApplicationJob
  queue_as :default

  # Configuração de tentativas e intervalo de reexecução caso haja falha
  retry_on ActiveRecord::RecordNotFound, wait: 5.seconds, attempts: 3

  # Método principal que executa a atualização do salário do proponente
  #
  # @param proponente_id [Integer] ID do proponente a ser atualizado
  # @param novo_salario [Float] Novo salário a ser atribuído ao proponente
  def perform(proponente_id, novo_salario)
    proponente = Proponente.find(proponente_id)

    # Inicia uma transação para garantir que a atualização seja atômica
    ActiveRecord::Base.transaction do
      proponente.update!(salario: novo_salario)
    end
  rescue StandardError => e
    # Caso ocorra um erro, o log é registrado para diagnóstico
    Rails.logger.error("Erro ao atualizar salário do proponente #{proponente_id}: #{e.message}")
    raise
  end
end
