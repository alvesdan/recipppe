<template>
  <p class="fragment fragment-paragraph"
      :ref="data.id"
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
    updateHTMLContent: function (event) {
      this.data.html_content = event.target.innerText
      let url = this.buildFragmentUpdateUrl(this.data)

      this.$http
        .patch(url, {
          fragment: {
            html_content:
            this.data.html_content
          }
        })
        .then(response => {
          this.data.updated_at = response.data.updated_at
          return
        }, response => {
          console.log("Error while updating fragment")
          return
        })
    }
  }
}
</script>

<style scoped>
</style>
