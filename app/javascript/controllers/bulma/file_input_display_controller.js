import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileInput", "fileList"]

  static ACCEPTED_FILE_TYPES = ["ofx", "qfx"]

  connect() {
    this.show()
  }

  show() {
    const preview = this.fileListTarget;
    this.#clear(preview)

    const curFiles = this.fileInputTarget.files;
    if (curFiles.length === 0) {
      const para = document.createElement("p")
      para.textContent = "No files currently selected for upload"
      preview.appendChild(para)
    } else {
      const list = document.createElement("ul")
      preview.appendChild(list)
  
      for (const file of curFiles) {
        const listItem = document.createElement("li")
        listItem.textContent =  this.#fileTextContent(file)
        list.appendChild(listItem);
      }
    }
  }

  #clear(preview) {
    while (preview.firstChild) {
      preview.removeChild(preview.firstChild);
    }
  }

  #fileTextContent(file) {
    if (this.#validFileType(file)) {
      return this.#fileInfo(file);
    } else {
      return `File name ${file.name}: Not a valid file type. Update your selection.`;
    }
  }

  #validFileType(file) {
    const parts = file.name.split('.')
    const extension = parts[parts.length - 1].toLowerCase()

    return this.constructor.ACCEPTED_FILE_TYPES.includes(extension)
  }

  #fileInfo(file) {
    return `${file.name} (${file.size} bytes)`
  }
}
