<template>
  <ol v-html="initialContent" class="fragment-ordered-list"
    v-if="data.fragment_type === 'ordered_list'"></ol>
  <ul v-html="initialContent" class="fragment-ordered-list" v-else></ul>
</template>

<script>
import Mixins from '../mixins.js'
export default {
  mixins: [ Mixins ],
  props: {
    data: Object,
  },
  data: function () {
    return {
      initialContent: this.data.html_content
    }
  },
  methods: {
    updateHTMLContent: function (event) {
      let content = this.$el.innerHTML
      if (this.data.html_content && this.data.html_content == content) {
        // Skip update when there is no change
        return
      }

      this.data.html_content = content
      this.$root.updateFragment(this)
    },
    addLineItemEditorAndListeners: function(lineItem) {
      lineItem.setAttribute("contenteditable", "true")
      lineItem.addEventListener("keydown", this.handleKeyDown)
      lineItem.addEventListener("paste", this.stripFormatting)
      lineItem.addEventListener("blur", this.updateHTMLContent)
    },
    createLineItem: function(event) {
      let lineItem = document.createElement("li")
      let currentItem = event.target
      let nextItem = currentItem.nextSibling

      this.addLineItemEditorAndListeners(lineItem)

      if(nextItem) {
        this.$el.insertBefore(lineItem, nextItem)
      } else {
        this.$el.append(lineItem)
      }

      this.placeCareAtEndOf(lineItem)
      this.updateHTMLContent()
    },
    handleKeyDown: function(event) {
      // Handling "enter"
      if (event.keyCode == 13) {
        event.preventDefault()
        this.createLineItem(event)
      }

      // Handling "backspace"
      if (event.keyCode == 8) {
        let content = event.target.innerText.trim()
        if (content == "") {
          event.preventDefault()
          let lineItem = event.target
          let previous = lineItem.previousSibling
          if (previous) {
            lineItem.parentNode.removeChild(lineItem)
            this.placeCareAtEndOf(previous)
            this.updateHTMLContent()
          } else {
            lineItem.removeEventListener("blur", this.updateHTMLContent)
            this.$root.removeFragment(this)
          }
        }
      }

      // Handling "arrow down"
      if (event.keyCode == 40) {
        event.preventDefault()
        let lineItem = event.target
        let next = lineItem.nextSibling
        if (next) {
          this.placeCareAtEndOf(next)
        }
      }

      // Handling "arrow up"
      if (event.keyCode == 38) {
        event.preventDefault()
        let lineItem = event.target
        let previous = lineItem.previousSibling
        if (previous) {
          this.placeCareAtEndOf(previous)
        }
      }
    },
    focusEndOfLastItem: function() {
      let lineItems = this.$el.getElementsByTagName("li")
      let lastItem = lineItems[lineItems.length - 1]
      this.placeCareAtEndOf(lastItem)
    }
  },
  mounted: function() {
    let lineItems = this.$el.getElementsByTagName("li")

    for (let lineItem of lineItems) {
      this.addLineItemEditorAndListeners(lineItem)
    }

    if (this.$root.allowAutoFocus) {
      this.focusEndOfLastItem()
    }
  }
}
</script>
