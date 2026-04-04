import { Controller } from "@hotwired/stimulus"

const TINYMCE_SRC = "https://cdn.jsdelivr.net/npm/tinymce@7/tinymce.min.js"

export default class extends Controller {
  static values = {
    height: { type: Number, default: 440 },
    plugins: {
      type: String,
      default:
        "advlist autolink lists link image charmap preview anchor searchreplace visualblocks code fullscreen insertdatetime media table help wordcount"
    },
    toolbar: {
      type: String,
      default:
        "undo redo | blocks fontsize | bold italic underline strikethrough | forecolor backcolor | " +
        "alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | " +
        "link table | code fullscreen removeformat | help"
    }
  }

  connect() {
    this.editor = null
    this._loadTinyMCE()
      .then(() => this._init())
      .catch((err) => console.error("[tinymce]", err))
  }

  disconnect() {
    if (this.editor) {
      try {
        this.editor.remove()
      } catch (_) {
        /* ignore */
      }
      this.editor = null
    }
  }

  _loadTinyMCE() {
    if (window.tinymce) return Promise.resolve()
    return new Promise((resolve, reject) => {
      const s = document.createElement("script")
      s.src = TINYMCE_SRC
      s.async = true
      s.referrerPolicy = "origin"
      s.onload = () => resolve()
      s.onerror = () => reject(new Error("Impossible de charger TinyMCE"))
      document.head.appendChild(s)
    })
  }

  _init() {
    window.tinymce.init({
      target: this.element,
      height: this.heightValue,
      menubar: false,
      base_url: "https://cdn.jsdelivr.net/npm/tinymce@7",
      suffix: ".min",
      license_key: "gpl",
      promotion: false,
      branding: false,
      plugins: this.pluginsValue,
      toolbar: this.toolbarValue,
      font_size_formats: "8pt 10pt 12pt 14pt 16pt 18pt 24pt 36pt",
      block_formats: "Paragraph=p; Heading 1=h1; Heading 2=h2; Heading 3=h3; Heading 4=h4",
      content_style:
        "body { font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; font-size: 16px; }",
      skin: "oxide",
      content_css: "default",
      setup: (editor) => {
        this.editor = editor
        editor.on("change input undo redo", () => {
          editor.save()
        })
      }
    })
  }
}
