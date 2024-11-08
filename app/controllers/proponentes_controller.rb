# ProponentesController: Controlador para gerenciar os proponentes no sistema.
class ProponentesController < ApplicationController
  before_action :set_proponente, only: %i[show edit update destroy]
  before_action :authenticate_user!

  def index
    @proponentes = Proponente.order(:nome).page(params[:page]).per(5)
  end

  def show
    @proponentes_por_faixa = ProponentesPresenter.new.faixas_salariais
  end

  def new
    @proponente = Proponente.new
    @proponente.telefones = {}
  end

  def create
    @proponente = Proponente.new(proponente_params)
  
    if @proponente.save
      sucesso_criacao
    else
      erro_criacao
    end
  end  

  def edit; end

  def update
    if @proponente.update(proponente_params)
      AtualizarSalarioJob.perform_later(@proponente.id, proponente_params[:salario])
      redirect_to @proponente, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @proponente.destroy
    redirect_to proponentes_url, notice: t('.success')
  end

  def calcular_inss
    salario = params.fetch(:salario, 0).to_f
    desconto = Proponente.calcular_desconto_inss(salario)
    
    render json: { desconto: desconto }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def relatorio
    @faixas = ProponentesPresenter.new.faixas_salariais
    
    respond_to do |format|
      format.html
      format.json { render json: @faixas }
    end
  end

  private

  def set_proponente
    @proponente = Proponente.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to proponentes_path, alert: t('proponentes.not_found')
  end

  def proponente_params
    params.require(:proponente).permit(
      :nome, :cpf, :data_nascimento, :logradouro,
      :numero, :bairro, :cidade, :estado, :cep,
      :salario, telefones: %i[pessoal referencia]
    )
  end

  # Método auxiliar para redirecionar após sucesso na criação
  def sucesso_criacao
    redirect_to @proponente, notice: t('proponentes.create.success')
  end

  # Método auxiliar para exibir mensagem de erro na criação
  def erro_criacao
    flash.now[:alert] = @proponente.errors.full_messages.to_sentence
    respond_to do |format|
      format.html { render :new }
      format.turbo_stream { render turbo_stream: turbo_stream.replace('form', partial: 'form', locals: { proponente: @proponente }) }
    end
  end
end
