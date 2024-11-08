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
  
        // Remove qualquer coisa que não seja número
        value = value.replace(/\D/g, "");
  
        // Adiciona a máscara de CPF (XXX.XXX.XXX-XX)
        if (value.length <= 11) {
          value = value.replace(/(\d{3})(\d{3})(\d{3})(\d{1,})/, "$1.$2.$3-$4");
        }else{
            return false
        }
  
        e.target.value = value;
      });
    }
  });
  