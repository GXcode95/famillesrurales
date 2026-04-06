import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay", "content", "menuButton", "header"]

  connect() {
    // Initialiser l'état de la sidebar au chargement
    this.initializeSidebar()
    
    // Gérer le resize pour adapter la sidebar
    this.handleResize = this.handleResize.bind(this)
    window.addEventListener('resize', this.handleResize)
  }

  disconnect() {
    window.removeEventListener('resize', this.handleResize)
  }

  toggle() {
    const isOpen = !this.sidebarTarget.classList.contains('-translate-x-full')
    
    if (isOpen) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.sidebarTarget.classList.remove('-translate-x-full')
    if (window.innerWidth < 768) {
      // Mobile : afficher l'overlay
      this.overlayTarget.classList.remove('hidden')
    }
    this.updateContentMargin(true)
    this.updateMenuButton(false)
    this.saveState(true)
  }

  close() {
    this.sidebarTarget.classList.add('-translate-x-full')
    this.overlayTarget.classList.add('hidden')
    this.updateContentMargin(false)
    this.updateMenuButton(true)
    this.saveState(false)
  }

  handleResize() {
    if (window.innerWidth >= 768) {
      // Desktop : cacher l'overlay, mais garder l'état de la sidebar
      this.overlayTarget.classList.add('hidden')
      const isOpen = !this.sidebarTarget.classList.contains('-translate-x-full')
      this.updateContentMargin(isOpen)
      this.updateMenuButton(!isOpen)
    } else {
      // Mobile : si la sidebar est ouverte, afficher l'overlay
      const isOpen = !this.sidebarTarget.classList.contains('-translate-x-full')
      if (isOpen) {
        this.overlayTarget.classList.remove('hidden')
        this.updateMenuButton(false)
      } else {
        this.overlayTarget.classList.add('hidden')
        this.updateMenuButton(true)
      }
      this.updateContentMargin(false)
    }
  }

  initializeSidebar() {
    const savedState = this.getSavedState()
    const isMobile = window.innerWidth < 768
    
    if (isMobile) {
      // Mobile : sidebar cachée par défaut
      this.sidebarTarget.classList.add('-translate-x-full')
      this.overlayTarget.classList.add('hidden')
      this.updateContentMargin(false)
      this.updateMenuButton(true)
    } else {
      // Desktop : restaurer l'état sauvegardé ou ouvrir par défaut
      const shouldOpen = savedState !== null ? savedState : true
      if (shouldOpen) {
        this.sidebarTarget.classList.remove('-translate-x-full')
        this.updateContentMargin(true)
        this.updateMenuButton(false)
      } else {
        this.sidebarTarget.classList.add('-translate-x-full')
        this.updateContentMargin(false)
        this.updateMenuButton(true)
      }
      this.overlayTarget.classList.add('hidden')
    }
  }

  updateContentMargin(isOpen) {
    if (this.hasContentTarget) {
      if (isOpen && window.innerWidth >= 768) {
        this.contentTarget.classList.add('md:ml-64')
        this.contentTarget.classList.remove('md:ml-0')
      } else {
        this.contentTarget.classList.remove('md:ml-64')
        this.contentTarget.classList.add('md:ml-0')
      }
    }
  }

  saveState(isOpen) {
    if (window.innerWidth >= 768) {
      localStorage.setItem('sidebarOpen', isOpen ? 'true' : 'false')
    }
  }

  getSavedState() {
    const saved = localStorage.getItem('sidebarOpen')
    return saved === null ? null : saved === 'true'
  }

  updateMenuButton(show) {
    if (this.hasMenuButtonTarget) {
      if (show) {
        this.menuButtonTarget.classList.remove('hidden')
      } else {
        this.menuButtonTarget.classList.add('hidden')
      }
    }
    // Masquer/afficher le header entier
    if (this.hasHeaderTarget) {
      if (show) {
        this.headerTarget.classList.remove('hidden')
      } else {
        this.headerTarget.classList.add('hidden')
      }
    }
  }
}
