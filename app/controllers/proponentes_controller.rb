class ProponentesController < ApplicationController
  before_action :set_proponente, only: [:show, :edit, :update, :destroy]

  def index
    @proponentes = Proponente.order(:nome).page(params[:page]).per(5)
  end

  def show
  end

  def new
    @proponente = Proponente.new
  end

  def create
    @proponente = Proponente.new(proponente_params)
    if @proponente.save
      redirect_to @proponente, notice: 'Proponente criado com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @proponente.update(proponente_params)
      redirect_to @proponente, notice: 'Proponente atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @proponente.destroy
    redirect_to proponentes_url, notice: 'Proponente excluído com sucesso.'
  end

  def calcular_inss
    salario = params[:salario].to_f
    desconto = calcular_desconto_inss(salario)
    render json: { desconto: desconto }
  end

  private

  def set_proponente
    @proponente = Proponente.find(params[:id])
  end

  def proponente_params
    params.require(:proponente).permit(:nome, :cpf, :data_nascimento, :logradouro, :numero, :bairro, :cidade, :estado, :cep, :salario, telefones: [:pessoal, :referencia])
  end

  def calcular_desconto_inss(salario)
    faixas = [
      { limite: 1045.00, aliquota: 0.075 },
      { limite: 2089.60, aliquota: 0.09 },
      { limite: 3134.40, aliquota: 0.12 },
      { limite: 6101.06, aliquota: 0.14 }
    ]
  
    desconto = 0
    salario_restante = salario
  
    faixas.each do |faixa|
      if salario_restante > 0
        base = [salario_restante, faixa[:limite]].min
        desconto += base * faixa[:aliquota]
        salario_restante -= base
      else
        break
      end
    end
  
    desconto.round(2)
  end

  def relatorio
    @faixas = [
      { min: 0, max: 1045.00, count: 0 },
      { min: 1045.01, max: 2089.60, count: 0 },
      { min: 2089.61, max: 3134.40, count: 0 },
      { min: 3134.41, max: 6101.06, count: 0 }
    ]
  
    Proponente.find_each do |proponente|
      faixa = @faixas.find { |f| proponente.salario.between?(f[:min], f[:max]) }
      faixa[:count] += 1 if faixa
    end
  end
end