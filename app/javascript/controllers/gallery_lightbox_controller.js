import { Controller } from "@hotwired/stimulus"

/** Diaporama plein écran : vignette, flèches, clavier, swipe tactile. */
export default class extends Controller {
  connect() {
    this.triggers = [...this.element.querySelectorAll("[data-lightbox-src]")]
    this.urls = this.triggers.map((el) => el.dataset.lightboxSrc)
    this.index = 0
    this.overlay = null
    this._touchStartX = null
    this._touchStartY = null
    this._onKeydown = this._onKeydown.bind(this)
  }

  disconnect() {
    document.removeEventListener("keydown", this._onKeydown)
    document.body.classList.remove("overflow-hidden")
    this.overlay?.remove()
    this.overlay = null
  }

  open(event) {
    const el = event.currentTarget
    const i = this.triggers.indexOf(el)
    if (i < 0 || this.urls.length === 0) return
    if (!this.overlay) {
      this._buildOverlay()
      document.body.appendChild(this.overlay)
    }
    this.index = i
    this._updateImage()
    this.overlay.classList.remove("hidden")
    this.overlay.setAttribute("aria-hidden", "false")
    document.body.classList.add("overflow-hidden")
    document.addEventListener("keydown", this._onKeydown)
    this.closeBtn?.focus({ preventScroll: true })
  }

  close() {
    this.overlay.classList.add("hidden")
    this.overlay.setAttribute("aria-hidden", "true")
    document.body.classList.remove("overflow-hidden")
    document.removeEventListener("keydown", this._onKeydown)
  }

  prev(event) {
    event?.stopPropagation()
    if (this.urls.length === 0) return
    this.index = (this.index - 1 + this.urls.length) % this.urls.length
    this._updateImage()
  }

  next(event) {
    event?.stopPropagation()
    if (this.urls.length === 0) return
    this.index = (this.index + 1) % this.urls.length
    this._updateImage()
  }

  _updateImage() {
    if (this.imgEl) this.imgEl.src = this.urls[this.index]
    const single = this.urls.length <= 1
    if (this.prevBtn) this.prevBtn.classList.toggle("hidden", single)
    if (this.nextBtn) this.nextBtn.classList.toggle("hidden", single)
  }

  _onKeydown(e) {
    if (e.key === "Escape") this.close()
    if (e.key === "ArrowLeft") this.prev()
    if (e.key === "ArrowRight") this.next()
  }

  _buildOverlay() {
    const root = document.createElement("div")
    root.className = "fixed inset-0 z-[100] hidden"
    root.setAttribute("role", "dialog")
    root.setAttribute("aria-modal", "true")
    root.setAttribute("aria-label", "Diaporama photo")
    root.setAttribute("aria-hidden", "true")

    root.innerHTML = `
      <div class="absolute inset-0 bg-black/90" tabindex="-1" data-lightbox-backdrop></div>
      <div class="pointer-events-none absolute inset-0 z-10 flex flex-col">
        <div class="pointer-events-auto flex justify-end p-2 sm:p-3">
          <button type="button" class="gallery-lightbox-close rounded-full bg-white/10 px-3 py-1.5 text-sm font-medium text-white backdrop-blur-sm transition hover:bg-white/20 focus:outline-none focus:ring-2 focus:ring-white/80" aria-label="Fermer">Fermer</button>
        </div>
        <div class="flex min-h-0 flex-1 items-center gap-2 px-2 pb-4 sm:gap-4 sm:px-4">
          <button type="button" class="gallery-lightbox-prev pointer-events-auto flex h-11 w-11 shrink-0 items-center justify-center self-center rounded-full bg-white/10 text-white shadow-lg backdrop-blur-sm transition hover:bg-white/20 focus:outline-none focus:ring-2 focus:ring-white/80 sm:h-12 sm:w-12" aria-label="Photo précédente">
            <svg class="h-6 w-6 sm:h-7 sm:w-7" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg>
          </button>
          <div class="pointer-events-auto flex min-h-0 min-w-0 flex-1 items-center justify-center" data-lightbox-swipe>
            <img class="max-h-[min(85vh,calc(100vh-8rem))] max-w-full object-contain select-none" alt="" data-lightbox-img />
          </div>
          <button type="button" class="gallery-lightbox-next pointer-events-auto flex h-11 w-11 shrink-0 items-center justify-center self-center rounded-full bg-white/10 text-white shadow-lg backdrop-blur-sm transition hover:bg-white/20 focus:outline-none focus:ring-2 focus:ring-white/80 sm:h-12 sm:w-12" aria-label="Photo suivante">
            <svg class="h-6 w-6 sm:h-7 sm:w-7" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
          </button>
        </div>
      </div>
    `

    this.overlay = root
    this.imgEl = root.querySelector("[data-lightbox-img]")
    this.prevBtn = root.querySelector(".gallery-lightbox-prev")
    this.nextBtn = root.querySelector(".gallery-lightbox-next")
    this.closeBtn = root.querySelector(".gallery-lightbox-close")
    const backdrop = root.querySelector("[data-lightbox-backdrop]")

    backdrop.addEventListener("click", () => this.close())
    this.prevBtn.addEventListener("click", (e) => this.prev(e))
    this.nextBtn.addEventListener("click", (e) => this.next(e))
    this.closeBtn.addEventListener("click", (e) => {
      e.stopPropagation()
      this.close()
    })
    this.imgEl.addEventListener("click", (e) => e.stopPropagation())

    const swipeZone = root.querySelector("[data-lightbox-swipe]")
    if (swipeZone) {
      swipeZone.addEventListener(
        "touchstart",
        (e) => {
          if (e.touches.length !== 1) return
          this._touchStartX = e.touches[0].clientX
          this._touchStartY = e.touches[0].clientY
        },
        { passive: true }
      )
      swipeZone.addEventListener(
        "touchcancel",
        () => {
          this._touchStartX = null
          this._touchStartY = null
        },
        { passive: true }
      )
      swipeZone.addEventListener(
        "touchend",
        (e) => {
          if (this._touchStartX == null || e.changedTouches.length !== 1) return
          const x = e.changedTouches[0].clientX
          const y = e.changedTouches[0].clientY
          const dx = x - this._touchStartX
          const dy = y - this._touchStartY
          this._touchStartX = null
          this._touchStartY = null

          const min = 48
          if (Math.abs(dx) < min) return
          if (Math.abs(dx) <= Math.abs(dy)) return

          e.preventDefault()
          if (dx < 0) this.next()
          else this.prev()
        },
        { passive: false }
      )
    }
  }
}
