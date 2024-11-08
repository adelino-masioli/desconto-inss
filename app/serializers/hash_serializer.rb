# ProponentesPresenter é responsável por apresentar as faixas salariais dos proponentes
# em formato estruturado. Cada faixa inclui o nome, o valor mínimo, máximo e a quantidade
# de proponentes dentro daquela faixa.
class HashSerializer
  def self.dump(hash)
    hash.to_json
  end

  def self.load(hash)
    return nil if hash.nil?

    JSON.parse(hash).with_indifferent_access
  rescue JSON::ParserError
    nil
  end
end
