class AtualizarSalarioJob < ApplicationJob
  queue_as :default

  retry_on ActiveRecord::RecordNotFound, wait: 5.seconds, attempts: 3

  def perform(proponente_id, novo_salario)
    proponente = Proponente.find(proponente_id)
    
    ActiveRecord::Base.transaction do
      proponente.update!(salario: novo_salario)
    end
  rescue StandardError => e
    Rails.logger.error("Erro ao atualizar salário do proponente #{proponente_id}: #{e.message}")
    raise
  end
end