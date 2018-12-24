/* eslint no-console: 0 */
// import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import VueResource from 'vue-resource'
import draggable from 'vuedraggable'
import VueTimeago from 'vue-timeago'
import Mixins from './mixins.js'
import FragmentHeader from './fragments/header.vue'
import FragmentParagraph from './fragments/paragraph.vue'
import FragmentList from './fragments/list.vue'
import FragmentMenu from './fragments/menu.vue'

// Vue.use(TurbolinksAdapter)
Vue.use(VueResource)
Vue.mixin(Mixins)
Vue.use(VueTimeago)

document.addEventListener('DOMContentLoaded', () => {
  Vue.http.headers.common['X-CSRF-Token'] =
    document
    .querySelector('meta[name="csrf-token"]')
    .getAttribute('content')

  const dataset = document.getElementById('editForm').dataset
  const recipeData = JSON.parse(dataset.recipe)
  const recipeFragments = JSON.parse(dataset.fragments)
  const defaultContent = {
    header: "",
    paragraph: "",
    ordered_list: "<li></li>",
    unordered_list: "<li></li>"
  }

  const EditedDateApp = new Vue({
    el: "#recipeDateCreated",
    data: function() {
      let lastEditedDate = recipeData.updated_at

      for (let fragment of recipeFragments) {
        if (fragment.updated_at > lastEditedDate) {
          lastEditedDate = fragment.updated_at
        }
      }
      return {
        recipeLastEditedTime: lastEditedDate
      }
    }
  })

  const app = new Vue({
    el: '#editForm',
    data: {
      recipe: recipeData,
      fragments: recipeFragments,
      fragmentHeader: FragmentHeader,
      fragmentParagraph: FragmentParagraph,
      fragmentList: FragmentList,
      fragmentSortableList: null,
      draggableEditable: false,
      allowAutoFocus: true
    },
    computed: {
      draggableOptions() {
        return {
          draggable: ".fragment",
          handle: ".draggable-handle",
          disabled: !this.draggableEditable
        }
      }
    },
    methods: {
      toggleDraggable: function() {
        this.draggableEditable = !this.draggableEditable
        this.$el.classList.toggle("drag-enabled");
        this.$el.getElementsByClassName("edit-order-button")[0].classList.toggle("btn-primary")
      },
      onDraggableEnd: function(event) {
        let htmlFragments = this.$el.getElementsByClassName("fragment"),
            positions = {},
            index = 0

        for (let fragment of htmlFragments) {
          positions[fragment.dataset.id] = { position: index }
          index++
        }
        this.updateFragmentsPositions(positions)
      },
      updateFragmentsPositions: function(positions) {
        let url = this.buildFragmentsPositionsUpdateUrl(this.recipe)

        this.$http
          .patch(url, { fragments: positions })
          .then(response => {
            // Positions have been updated
          }, response => {
            console.log("Error while creating fragment")
            return
          })
      },
      addFragment: function(event) {
        let type = event.target.dataset.type,
            url = this.buildFragmentCreateUrl(this.recipe),
            position = this.fragments.length,
            params = {
              fragment: {
                fragment_type: type,
                html_content: defaultContent[type],
                position: position
              }
            }

        this.$http
          .post(url, params)
          .then(response => {
            let fragment = response.data
            this.fragments.push(fragment)
            EditedDateApp.$data.recipeLastEditedTime = response.data.created_at
            return
          }, response => {
            console.log("Error while creating fragment")
            return
          })
      },
      updateFragment: function(fragment) {
        let url = this.buildFragmentUpdateUrl(fragment.data),
            params = {
              fragment: {
                html_content: fragment.data.html_content
              }
            }

        this.$http
          .patch(url, params)
          .then(response => {
            fragment.data.updated_at = response.data.updated_at
            EditedDateApp.$data.recipeLastEditedTime = response.data.updated_at
            return
          }, response => {
            console.log("Error while updating fragment")
            return
          })
      },
      removeFragment: function(fragment) {
        let previous = null,
            index = this.fragments.indexOf(fragment.data),
            url = this.buildFragmentDeleteUrl(fragment.data)

        if (fragment.$el) {
          previous = fragment.$el.parentElement.previousElementSibling
        }

        this.allowAutoFocus = false
        this.fragments.splice(index, 1)

        this.$http
          .delete(url)
          .then(response => {
            // Fragment deleted
            if (previous) {
              let items = previous.querySelectorAll("[contenteditable=true]"),
                  lastItem = items[items.length - 1]
              this.placeCareAtEndOf(lastItem)
            }
            this.allowAutoFocus = true
            EditedDateApp.$data.recipeLastEditedTime = fragment.data.updated_at
            return
          }, response => {
            console.log("Error while removing fragment")
            return
          })
      }
    },
    components: {
      draggable,
      FragmentMenu
    }
  })
})
