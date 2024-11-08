# Migration to add a new column `desconto_inss` to the `proponentes` table.
# This column will store the INSS discount value as a decimal for each proponente.
# The column will help calculate and store the discount on INSS contributions.
class AddDescontoInssToProponentes < ActiveRecord::Migration[7.0]
  def change
    add_column :proponentes, :desconto_inss, :decimal
  end
end
