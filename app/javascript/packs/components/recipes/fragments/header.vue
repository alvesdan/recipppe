<template>
  <h2 class="fragment-header"
      contenteditable dir="auto"
      v-html="data.html_content"
      @keydown.enter.prevent
      @keydown.backspace="handleBackspace($event)"
      @paste="stripFormatting($event)"
      @blur="updateHTMLContent($event)">
  </h2>
</template>

<script>
import Mixins from '../mixins.js'
export default {
  mixins: [ Mixins ],
  props: {
    data: Object
  },
  methods: {
    updateHTMLContent: function (event) {
      if (this.data.html_content && this.data.html_content.trim() == event.target.innerText.trim()) {
        // Skip update when there is no change
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

<style scoped>
h2 {
  font-size: 2em;
  text-align: center;
}
</style>
