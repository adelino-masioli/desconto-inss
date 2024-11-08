# ProponentesPresenter é responsável por apresentar as faixas salariais dos proponentes
# em formato estruturado. Cada faixa inclui o nome, o valor mínimo, máximo e a quantidade
# de proponentes dentro daquela faixa.
class ProponentesPresenter
  def faixas_salariais
    [
      { nome: 'Até R$ 1.045,00', min: 0, max: 1_045.00, count: Proponente.faixa1.count },
      { nome: 'R$ 1.045,01 a R$ 2.089,60', min: 1_045.01, max: 2_089.60, count: Proponente.faixa2.count },
      { nome: 'R$ 2.089,61 a R$ 3.134,40', min: 2_089.61, max: 3_134.40, count: Proponente.faixa3.count },
      { nome: 'R$ 3.134,41 a R$ 6.101,06', min: 3_134.41, max: 6_101.06, count: Proponente.faixa4.count }
    ]
  end
end
