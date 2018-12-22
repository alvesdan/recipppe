<template>
  <p class="fragment-paragraph"
      contenteditable dir="auto"
      v-html="data.html_content"
      @keydown.enter.prevent
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
      if (this.data.html_content.trim() == event.target.innerText.trim()) {
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
