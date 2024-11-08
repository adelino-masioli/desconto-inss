class CreateProponentes < ActiveRecord::Migration[7.0]
  def change
    create_table :proponentes do |t|
      t.string :nome
      t.string :cpf
      t.date :data_nascimento
      t.string :logradouro  # Certifique-se de que esta linha existe
      t.string :numero
      t.string :bairro
      t.string :cidade
      t.string :estado
      t.string :cep
      t.json :telefones
      t.decimal :salario, precision: 10, scale: 2

      t.timestamps
    end
  end
end