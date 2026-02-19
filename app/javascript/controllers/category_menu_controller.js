import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "icon"]

  toggle(event) {
    event.preventDefault()
    const menu = this.menuTarget
    const icon = this.iconTarget
    
    // Toggle la visibilité du menu
    menu.classList.toggle("hidden")
    
    // Toggle l'icône (rotation)
    icon.classList.toggle("rotate-90")
  }
}
