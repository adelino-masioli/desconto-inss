import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["salarioInput", "descontoElement"];

  async calcularDesconto() {
    if (!this.hasDescontoElementTarget) {
      console.error("Desconto element target is missing");
      return;
    }

    const salario = parseFloat(this.salarioInputTarget.value);
    if (isNaN(salario) || salario <= 0) {
      this.descontoElementTarget.classList.add("d-none");
      this.descontoElementTarget.classList.remove("d-block");
      return;
    }

    try {
      const response = await fetch(`/proponentes/calcular_inss?salario=${salario}`);
      const data = await response.json();

      if (response.ok) {
        this.descontoElementTarget.textContent = `Desconto INSS: R$ ${data.desconto.toFixed(2)}`;
        this.descontoElementTarget.classList.remove("d-none");
        this.descontoElementTarget.classList.add("d-block");
      } else {
        this.descontoElementTarget.classList.add("d-none");
        this.descontoElementTarget.classList.remove("d-block");
      }
    } catch (error) {
      console.error("Erro ao calcular INSS:", error);
      this.descontoElementTarget.classList.add("d-none");
      this.descontoElementTarget.classList.remove("d-block");
    }
  }

}
