class AddDescontoInssToProponentes < ActiveRecord::Migration[7.0]
  def change
    add_column :proponentes, :desconto_inss, :decimal
  end
end
