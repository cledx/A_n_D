import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["avatar"]

  select(event) {
    this.avatarTargets.forEach((avatar) => {
      avatar.classList.remove("avatar-selected")
    })

    const clickedImage = event.currentTarget.querySelector("img")
    clickedImage.classList.add("avatar-selected")
  }
}
