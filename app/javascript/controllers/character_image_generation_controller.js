import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="character-image-generation"
export default class extends Controller {
  static targets = ["steps", "appearanceInput", "appearanceInputContainer", "preview", "races", "classes", "genders", "generateBtn", "imageFile"]
  connect() {
    this.currentPage = 0
  }

  showStep() {
    this.stepsTargets.forEach((step,index) => {
      if (this.currentPage == index) {
        step.classList.remove("d-none")
      } else {
        step.classList.add("d-none")
      }
    });
  }

  next() {
    this.currentPage += 1
    this.showStep()
  }

  previous() {
     this.currentPage -= 1
    this.showStep()
  }

  showInput() {
    this.appearanceInputContainerTarget.classList.toggle("d-none")
  }

  generateImage() {
    console.log("generating image");
    const raceChecked = this.racesTargets.find(el=>el.checked);
    const charClassChecked = this.classesTargets.find(el=>el.checked);
    const genderChecked = this.gendersTargets.find(el=>el.checked);

    const race = raceChecked ? raceChecked.value : "";
    const charClass = charClassChecked ? charClassChecked.value : "";
    const gender = genderChecked ? genderChecked.value : "";
    const appearanceDescription = this.appearanceInputTarget.value;


    if (race == "" || charClass == "" || gender == "") {
      alert("Please fill all required fields and appearance description.");
      return;
    }

    this.generateBtnTarget.innerText = "Generating..."
    this.generateBtnTarget.disabled = true

    try {
      fetch("/characters/generate_appearance", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ race, character_class: charClass, gender, appearance_description: appearanceDescription })
      }).then(response => response.json()).then(data=>{
        if (data.url) this.previewTarget.src = data.url;
        this.generateBtnTarget.innerText = "Generate Again"
        this.generateBtnTarget.disabled = false
        this.imageFileTarget.value = data.url
        this.generateBtnTarget.insertAdjacentHTML("afterend", `<input type="submit" name="commit" value="Create Character" class="btn btn-secondary" data-disable-with="Create Character"></input>`)
      })
    } catch (error) {
      console.error(error);
      alert("Error generating image.");
    }
  }
}
