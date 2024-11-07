class CreateProponentes < ActiveRecord::Migration[7.0]
  def change
    create_table :proponentes do |t|
      t.string :nome
      t.string :cpf
      t.date :data_nascimento
      t.string :endereco
      t.string :telefone_contato
      t.decimal :salario

      t.timestamps
    end
  end
end
