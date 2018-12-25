<template>
  <p class="fragment-paragraph"
      contenteditable dir="auto"
      v-html="data.html_content"
      @keydown.enter.prevent
      @keydown.backspace="handleBackspace($event)"
      @paste="stripFormatting($event)"
      @blur="updateHTMLContent($event)">
  </p>
</template>

<script>
import Mixins from '../mixins.js'
export default {
  mixins: [ Mixins ],
  props: {
    data: Object
  },
  methods: {
    updateHTMLContent: function(event) {
      if (this.data.html_content &&
          this.data.html_content.trim() == event.target.innerText.trim()) {
        return
      }

      this.data.html_content = event.target.innerText.trim()
      this.$root.updateFragment(this)
    },
    handleBackspace: function(event) {
      let content = this.$el.innerText.trim()
      if (content == "") {
        event.preventDefault()
        this.$el.removeEventListener("blur", this.updateHTMLContent)
        this.$root.removeFragment(this)
      }
    }
  },
  mounted: function() {
    if (this.$root.allowAutoFocus) {
      this.placeCareAtEndOf(this.$el)
    }
  }
}
</script>
