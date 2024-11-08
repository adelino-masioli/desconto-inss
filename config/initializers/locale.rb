Rails.application.config.i18n.default_locale = :'pt-BR'

# Configuração global para number_to_currency
ActionView::Helpers::NumberHelper.class_eval do
  def number_to_currency_with_br_defaults(number, options = {})
    options = {
      unit: "R$",
      separator: ",",
      delimiter: ".",
      format: "%u %n"
    }.merge(options)

    number_to_currency_without_br_defaults(number, options)
  end

  alias_method :number_to_currency_without_br_defaults, :number_to_currency
  alias_method :number_to_currency, :number_to_currency_with_br_defaults
end
