import { Controller } from "@hotwired/stimulus"

/** Affiche / masque un panneau (ex. formulaire de commentaire). */
export default class extends Controller {
  static targets = ["panel", "buttonText", "trigger"]

  toggle() {
    this.panelTarget.classList.toggle("hidden")
    const isOpen = !this.panelTarget.classList.contains("hidden")
    if (this.hasTriggerTarget) {
      this.triggerTarget.setAttribute("aria-expanded", isOpen ? "true" : "false")
    }
    if (this.hasButtonTextTarget) {
      this.buttonTextTarget.textContent = isOpen
        ? "Masquer le formulaire"
        : "Ajouter un commentaire"
    }
  }
}
