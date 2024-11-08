// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";


import "bootstrap";
import "popper";


import { Application } from "@hotwired/stimulus";
import "chart.js";
//controllers
import ProponenteController from "./controllers/proponente_controller";

const application = Application.start()
application.register("proponente", ProponenteController)


document.addEventListener("DOMContentLoaded", function() {
  const cpfInput = document.querySelector("#cpf-input");

  if (cpfInput) {
      cpfInput.addEventListener("input", function(e) {
          let value = e.target.value;

          // Remove qualquer caractere que não seja número
          value = value.replace(/\D/g, "");

          // Limita o input a 11 dígitos
          value = value.slice(0, 11);

          // Aplica a máscara de CPF (XXX.XXX.XXX-XX)
          value = value.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, "$1.$2.$3-$4");

          // Remove o último ponto ou traço se o CPF estiver incompleto
          value = value.replace(/\.$/, "").replace(/-$/, "");

          e.target.value = value;
      });

      // Adiciona validação ao perder o foco
      cpfInput.addEventListener("blur", function(e) {
          let value = e.target.value.replace(/\D/g, "");
          if (value.length !== 11) {
              alert("CPF inválido. Por favor, insira 11 dígitos.");
              e.target.value = "";
          }
      });
  }
});