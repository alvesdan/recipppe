export default {
  methods: {
    joinPath: function(paths) {
      return "/" + paths.join("/")
    },
    buildFragmentCreateUrl: function(recipe) {
      return this.joinPath([
        "recipes",
        recipe.id,
        "fragments.json"
      ])
    },
    buildFragmentUpdateUrl: function(fragment) {
      return this.joinPath([
        "recipes",
        fragment.recipe_id,
        "fragments",
        fragment.id + ".json"
      ])
    },
    buildFragmentDeleteUrl: function(fragment) {
      return this.joinPath([
        "recipes",
        fragment.recipe_id,
        "fragments",
        fragment.id + ".json"
      ])
    },
    buildFragmentsPositionsUpdateUrl: function(recipe) {
      return this.joinPath([
        "recipes",
        recipe.id,
        "/update_fragments_positions.json"
      ])
    },
    placeCareAtEndOf: function(el) {
      el.focus()
      if (typeof window.getSelection != "undefined" &&
          typeof document.createRange != "undefined") {
        let range = document.createRange()
        range.selectNodeContents(el)
        range.collapse(false)
        let sel = window.getSelection()
        sel.removeAllRanges()
        sel.addRange(range)
      } else if (typeof document.body.createTextRange != "undefined") {
        let textRange = document.body.createTextRange()
        textRange.moveToElementText(el)
        textRange.collapse(false)
        textRange.select()
      }
    },
    stripFormatting: function(e) {
      e.preventDefault()
      let text = e.clipboardData.getData("text/plain")
      text = text.replace(/(?:\r\n|\r|\n)/g, ' ')
      document.execCommand("insertHTML", false, text)
    }
  }
}
