import { Controller } from "@hotwired/stimulus"

if (!window.__pwaDeferredPromptInitialized) {
  window.__pwaDeferredPromptInitialized = true
  window.__pwaDeferredPrompt = null

  window.addEventListener("beforeinstallprompt", (e) => {
    e.preventDefault()
    window.__pwaDeferredPrompt = e
    window.dispatchEvent(new CustomEvent("pwa:deferred-prompt"))
  })
}

export default class extends Controller {
  static targets = [
    "panelInstalled",
    "panelSafariIos",
    "panelSafariMac",
    "panelChromium",
    "safariIosLoader",
    "safariIosContent",
    "safariMacLoader",
    "safariMacContent",
    "chromiumLoader",
    "chromiumContent",
    "chromiumFallback",
    "installButton",
    "installedToast",
  ]

  connect() {
    this.deferredPrompt = window.__pwaDeferredPrompt

    this._onDeferredPromptReady = () => {
      if (this._activeMode !== "chromium") return
      this.deferredPrompt = window.__pwaDeferredPrompt
      this._maybeShowInstallButton()
    }

    window.addEventListener("pwa:deferred-prompt", this._onDeferredPromptReady)

    this._onAppInstalled = () => {
      this.deferredPrompt = null
      window.__pwaDeferredPrompt = null

      if (this.hasInstallButtonTarget) {
        this.installButtonTarget.classList.add("hidden")
      }

      if (this.hasInstalledToastTarget) {
        if (this._activeMode === "chromium") {
          this._revealChromiumContent()
        }
        this.installedToastTarget.classList.remove("hidden")
      }
    }

    window.addEventListener("appinstalled", this._onAppInstalled)

    this._showInitialPanel()

    if (this._activeMode === "safari_ios" || this._activeMode === "safari_mac") {
      this._safariRevealTimer = window.setTimeout(() => {
        if (this._activeMode === "safari_ios") {
          this._revealSafariIosContent()
        } else if (this._activeMode === "safari_mac") {
          this._revealSafariMacContent()
        }
      }, 1200)
    } else if (this._activeMode === "chromium") {
      this.deferredPrompt = window.__pwaDeferredPrompt
      if (this.deferredPrompt) {
        this._revealChromiumContent()
        this._maybeShowInstallButton()
      }

      this._chromiumTimer = window.setTimeout(() => {
        if (this._activeMode !== "chromium") return
        this.deferredPrompt = window.__pwaDeferredPrompt
        if (!this.deferredPrompt && this.hasChromiumFallbackTarget) {
          this.chromiumFallbackTarget.classList.remove("hidden")
        }
        this._revealChromiumContent()
      }, 4000)
    }
  }

  disconnect() {
    window.removeEventListener("pwa:deferred-prompt", this._onDeferredPromptReady)
    window.removeEventListener("appinstalled", this._onAppInstalled)
    if (this._safariRevealTimer) window.clearTimeout(this._safariRevealTimer)
    if (this._chromiumTimer) window.clearTimeout(this._chromiumTimer)
  }

  async install() {
    if (!this.deferredPrompt) return

    this.deferredPrompt.prompt()
    const choice = await this.deferredPrompt.userChoice

    if (choice.outcome === "accepted") {
      // opcional: analytics
    }

    this.deferredPrompt = null
    window.__pwaDeferredPrompt = null

    if (this.hasInstallButtonTarget) {
      this.installButtonTarget.classList.add("hidden")
    }
  }

  _revealSafariIosContent() {
    if (this.hasSafariIosLoaderTarget) {
      this.safariIosLoaderTarget.classList.add("hidden")
    }
    if (this.hasSafariIosContentTarget) {
      this.safariIosContentTarget.classList.remove("hidden")
    }
  }

  _revealSafariMacContent() {
    if (this.hasSafariMacLoaderTarget) {
      this.safariMacLoaderTarget.classList.add("hidden")
    }
    if (this.hasSafariMacContentTarget) {
      this.safariMacContentTarget.classList.remove("hidden")
    }
  }

  _revealChromiumContent() {
    if (this.hasChromiumLoaderTarget) {
      this.chromiumLoaderTarget.classList.add("hidden")
    }
    if (this.hasChromiumContentTarget) {
      this.chromiumContentTarget.classList.remove("hidden")
    }
  }

  _maybeShowInstallButton() {
    if (this.deferredPrompt && this.hasInstallButtonTarget) {
      this._revealChromiumContent()
      this.installButtonTarget.classList.remove("hidden")
    }
  }

  _isStandalone() {
    return (
      window.matchMedia("(display-mode: standalone)").matches ||
      window.matchMedia("(display-mode: fullscreen)").matches ||
      window.navigator.standalone === true
    )
  }

  _isIos() {
    const ua = navigator.userAgent
    if (/iPad|iPhone|iPod/.test(ua)) return true
    return navigator.platform === "MacIntel" && navigator.maxTouchPoints > 1
  }

  _isSafari() {
    const ua = navigator.userAgent.toLowerCase()
    return ua.includes("safari") && !ua.includes("chrome") && !ua.includes("android")
  }

  _hideAllPanels() {
    this.panelInstalledTarget?.classList.add("hidden")
    this.panelSafariIosTarget?.classList.add("hidden")
    this.panelSafariMacTarget?.classList.add("hidden")
    this.panelChromiumTarget?.classList.add("hidden")
    this.chromiumFallbackTarget?.classList.add("hidden")
  }

  _showInitialPanel() {
    this._hideAllPanels()

    if (this._isStandalone()) {
      this._activeMode = "installed"
      this.panelInstalledTarget?.classList.remove("hidden")
      return
    }

    if (this._isSafari()) {
      if (this._isIos()) {
        this._activeMode = "safari_ios"
        this.panelSafariIosTarget?.classList.remove("hidden")
      } else {
        this._activeMode = "safari_mac"
        this.panelSafariMacTarget?.classList.remove("hidden")
      }
      return
    }

    this._activeMode = "chromium"
    this.panelChromiumTarget?.classList.remove("hidden")

    this.installButtonTarget?.classList.add("hidden")
  }
}
