import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "panelInstalled",
    "panelSafariIos",
    "panelSafariMac",
    "panelChromium",
    "chromiumFallback",
    "installButton",
    "installedToast",
  ]

  connect() {
    this.deferredPrompt = null
    this._onBeforeInstall = (e) => {
      e.preventDefault()
      this.deferredPrompt = e
      if (this.hasInstallButtonTarget) {
        this.installButtonTarget.classList.remove("hidden")
      }
    }
    this._onAppInstalled = () => {
      this.deferredPrompt = null
      if (this.hasInstallButtonTarget) {
        this.installButtonTarget.classList.add("hidden")
      }
      if (this.hasInstalledToastTarget) {
        this.installedToastTarget.classList.remove("hidden")
      }
    }

    window.addEventListener("beforeinstallprompt", this._onBeforeInstall)
    window.addEventListener("appinstalled", this._onAppInstalled)

    this._showInitialPanel()

    this._chromiumTimer = window.setTimeout(() => {
      if (this._activeMode === "chromium" && !this.deferredPrompt && this.hasChromiumFallbackTarget) {
        this.chromiumFallbackTarget.classList.remove("hidden")
      }
    }, 8000)
  }

  disconnect() {
    window.removeEventListener("beforeinstallprompt", this._onBeforeInstall)
    window.removeEventListener("appinstalled", this._onAppInstalled)
    if (this._chromiumTimer) window.clearTimeout(this._chromiumTimer)
  }

  async install() {
    if (!this.deferredPrompt) return
    this.deferredPrompt.prompt()
    await this.deferredPrompt.userChoice
    this.deferredPrompt = null
    if (this.hasInstallButtonTarget) {
      this.installButtonTarget.classList.add("hidden")
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

  _isSafariMac() {
    const ua = navigator.userAgent
    return /^((?!chrome|android).)*safari/i.test(ua) && !this._isIos()
  }

  _hideAllPanels() {
    if (this.hasPanelInstalledTarget) this.panelInstalledTarget.classList.add("hidden")
    if (this.hasPanelSafariIosTarget) this.panelSafariIosTarget.classList.add("hidden")
    if (this.hasPanelSafariMacTarget) this.panelSafariMacTarget.classList.add("hidden")
    if (this.hasPanelChromiumTarget) this.panelChromiumTarget.classList.add("hidden")
    if (this.hasChromiumFallbackTarget) this.chromiumFallbackTarget.classList.add("hidden")
  }

  _showInitialPanel() {
    this._hideAllPanels()

    if (this._isStandalone()) {
      this._activeMode = "installed"
      if (this.hasPanelInstalledTarget) {
        this.panelInstalledTarget.classList.remove("hidden")
      }
      return
    }

    if (this._isIos()) {
      this._activeMode = "safari_ios"
      if (this.hasPanelSafariIosTarget) {
        this.panelSafariIosTarget.classList.remove("hidden")
      }
      return
    }

    if (this._isSafariMac()) {
      this._activeMode = "safari_mac"
      if (this.hasPanelSafariMacTarget) {
        this.panelSafariMacTarget.classList.remove("hidden")
      }
      return
    }

    this._activeMode = "chromium"
    if (this.hasPanelChromiumTarget) {
      this.panelChromiumTarget.classList.remove("hidden")
    }
    if (this.hasInstallButtonTarget) {
      this.installButtonTarget.classList.add("hidden")
    }
  }
}
