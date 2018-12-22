<template>
  <h2 class="fragment-header"
      contenteditable dir="auto"
      v-html="data.html_content"
      @keydown.enter.prevent
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
      if (this.data.html_content.trim() == event.target.innerText.trim()) {
        // Skip update when there is no change
        return
      }

      this.data.html_content = event.target.innerText.trim()
      this.$root.updateFragment(this)
    }
  },
  mounted: function() {
    this.placeCareAtEndOf(this.$el)
  }
}
</script>

<style scoped>
h2 {
  font-size: 2em;
  text-align: center;
}
</style>
